import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/providers/utils.dart';
import 'package:my_quotes/screens/fav_screen.dart';
import 'package:my_quotes/screens/make_quote.dart';

import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/services/local_notification_service.dart';

import 'package:my_quotes/widgets/carousal_screen.dart';
import 'package:my_quotes/widgets/change_theme.dart';
import 'package:my_quotes/widgets/home_drawer.dart';
import 'package:my_quotes/widgets/speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/my_card.dart';
import 'blessings.dart';
import 'funny_pg.dart';
import 'health.dart';
import 'inspiration.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? userId;
  UserCredential? userCredential;

  getUserId() async {
    userCredential = await FirebaseAuth.instance.signInAnonymously();
    userId = userCredential!.user!.uid;
  }

  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .orderBy("time", descending: true)
      .snapshots();

  final isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    getUserId();
    LocalNotificationService.initialize(context);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final lang = AppLocalizations.of(context)!;
    final lang2 = Provider.of<LocaleProvider>(context).locale.languageCode;

    return DefaultTabController(
      length: 6,
      child: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          drawer: HomeDrawer(shareApp: () => Share.share("")),
          appBar: AppBar(
            bottom: TabBar(isScrollable: true, tabs: [
              const Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                child: Text(
                  lang.funny,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.favorites,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.health,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.blessings,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.inspiring,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            toolbarHeight: media.height * 0.05,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: media.width * .35,
                  child: FittedBox(
                    child: Text(
                      'QuotesBook',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontFamily: "Lobster",
                            fontSize: media.width * .025,
                          ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.newQuote,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontFamily: "RobotoCondensed",
                          fontSize: media.width * .029,
                        ),
                  ),
                ),
              ],
            ),
            actions: const [
              ChangeTheme(),
              //
            ],
          ),
          floatingActionButton:
              CustomSpeedDial(isDialOpen: isDialOpen, lang: lang),
          floatingActionButtonLocation:
              lang2 == "ar" || lang2 == "fa" || lang2 == "ur"
                  ? FloatingActionButtonLocation.startFloat
                  : FloatingActionButtonLocation.endFloat,
          body: TabBarView(
            children: [
              HomePage(quotes: quotes, media: media),
              FunnyPage(),
              Inspiration(),
              Blessings(),
              FavScreen(),
              HealthScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.quotes,
    required this.media,
  }) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> quotes;
  final Size media;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Locale? locale;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: StreamBuilder(
        stream: widget.quotes,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('error .....');
          }
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: media.height * 0.65,
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = snapshot.data.doc[index];
                      String content = doc["content"];
                      String quoteId = doc[index].id;

                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                          dismissible: DismissiblePane(
                            onDismissed: ()
                                // async
                                {},
                          ),
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              label: 'Download',
                              backgroundColor: Colors.amber,
                              icon: Icons.download,
                              onPressed: (context) {
                                Utils.save(doc["imgUrl"], context);
                              },
                            ),

// !  Admin
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                            //! return Slidable(
                            //   key: UniqueKey(),
                            //   endActionPane: ActionPane(
                            //     dismissible: DismissiblePane(
                            //       onDismissed: () async {
                            //         await FirebaseFirestore.instance.runTransaction(
                            //             (Transaction myTransaction) async {
                            //           myTransaction.delete(
                            //               doc.reference);
                            //         });
                            //         await FirebaseStorage.instance
                            //             .refFromURL(
                            //                 doc["imgUrl"])
                            //             .delete();
                            //         // Remove this Slidable from the widget tree.
                            //       },
                            //     ),
                            //     motion: const DrawerMotion(),
                            //     extentRatio: 0.25,
                            //     children: [
                            //       SlidableAction(
                            //         label: 'Delete',
                            //         backgroundColor: Colors.red,
                            //         icon: Icons.delete,
                            //         onPressed: (context) {},
                            //       ),
                            // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuoteImage(
                                  content: content,
                                  imgUrl: doc["imgUrl"],
                                  docId: quoteId,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: widget.media.width,
                            height: widget.media.height * 0.2,
                            child: Stack(children: [
                              Positioned(child: MyCard(details: content)),
                              Positioned(
                                top: 5,
                                child: Container(
                                  height: widget.media.height * 0.2,
                                  width: widget.media.height * 0.2,
                                  decoration: BoxDecoration(
                                    boxShadow: const [BoxShadow(blurRadius: 2)],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(doc["imgUrl"]),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
              ),
              Sliders(imgs: snapshot),
              Container(
                height: 50,
              )
            ],
          );
        },
      ),
    );
  }
}
