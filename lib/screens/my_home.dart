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
import 'package:my_quotes/screens/fav_screen.dart';
import 'package:my_quotes/screens/make_quote.dart';

import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/services/local_notification_service.dart';

import 'package:my_quotes/widgets/carousal_screen.dart';
import 'package:my_quotes/widgets/change_theme.dart';
import 'package:my_quotes/widgets/home_drawer.dart';
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
          floatingActionButton: SpeedDial(
            // useRotationAnimation: true,
            // switchLabelPosition: true,
            openCloseDial: isDialOpen,
            overlayColor: Colors.transparent,
            animatedIcon: AnimatedIcons.add_event,
            animatedIconTheme: const IconThemeData(size: 30),
            children: [
              SpeedDialChild(
                  backgroundColor: Colors.pink[100],
                  child: Icon(Icons.share),
                  label: lang.shareApp,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  onTap: () {
                    Share.share(
                        "https://play.google.com/store/apps/details?id=com.DrHamaida.quotesBook");
                  }),
              SpeedDialChild(
                  backgroundColor: Colors.pink[100],
                  child: Icon(Icons.imagesearch_roller),
                  label: "Make Your\n Own Quote",
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MakeQuote()));
                  }),
            ],
          ),
          // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              lang2 == "ar" || lang == "fa" || lang == "ur"
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
          // bottomSheet: Container(
          //   height: media.height * .1,
          //   width: media.width,
          //   padding: Provider.of<LocaleProvider>(context).locale.languageCode ==
          //               "ar" ||
          //           Provider.of<LocaleProvider>(context).locale.languageCode ==
          //               "fa" ||
          //           Provider.of<LocaleProvider>(context).locale.languageCode == "ur"
          //       ? EdgeInsets.only(
          //           right: 10, left: media.width * .21, top: 10, bottom: 5)
          //       : EdgeInsets.only(
          //           right: media.width * .24, left: 10, top: 10, bottom: 5),
          //   // decoration: BoxDecoration(color: Colors.pink[300]),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         AutoSizeText(
          //           AppLocalizations.of(context)!.fixedQuote,
          //           maxLines: 2,
          //           // minFontSize: 10,
          //           // maxFontSize: 13,
          //           style: Theme.of(context).textTheme.headline6!.copyWith(
          //                 //  fontFamily: "RobotoCondensed",
          //                 fontSize: media.width * .029,
          //               ),

          //           //  TextStyle(
          //           //     fontSize: media.width * .02,
          //           //     color: Colors.black,
          //           //     // 7w7
          //           //     fontFamily: "Raleway"),
          //         ),
          //         AutoSizeText(
          //           AppLocalizations.of(context)!.spread,
          //           maxLines: 1,
          //           // minFontSize: media.width * .03,
          //           // maxFontSize: media.width * .05,
          //           style: Theme.of(context).textTheme.headline5!.copyWith(
          //                 fontSize: media.width * 0.04,
          //                 fontWeight: FontWeight.bold,
          //               ),

          //           //  TextStyle(
          //           //     fontSize: media.width * 0.04,
          //           //     fontWeight: FontWeight.bold,
          //           //     color: Colors.black,
          //           //     fontFamily: "Raleway"
          //           //     // fontFamily: "RobotoCondensed",
          //           //     ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniEndDocked,
          // floatingActionButton:

          //  FloatingActionButton(
          //     child: Icon(
          //       Icons.share,
          //       size: media.width * 0.05,
          //       color: MediaQuery.of(context).platformBrightness == ThemeMode.dark
          //           ? Colors.white
          //           : Colors.black,
          //     ),
          // label: Text(
          //   AppLocalizations.of(context)!.share,
          //   style: Theme.of(context).textTheme.headline5!.copyWith(
          //         fontSize: media.width * 0.02,
          //         fontWeight: FontWeight.bold,
          //       ),

          //   //  TextStyle(
          //   //   fontSize: media.width * 0.03,
          //   //   color: Colors.black,
          //   //   fontWeight: FontWeight.bold,
          //   //   // fontFamily: "Raleway"
          //   //   fontFamily: "RobotoCondensed",
          //   // ),
          // ),
          // onPressed: () {
          //   // // ! admin
          //   Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const UploadScreen(),
          //   ));
          //   // ! user
          //   // Share.share(
          //   //     "https://play.google.com/store/apps/details?id=com.DrHamaida.quotesBook");
          // }
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

  // @override
  // void didChangeDependencies() {
  //   locale = Localizations.localeOf(context);

  //   super.didChangeDependencies();
  // }

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
                      String content = snapshot.data.docs[index]["content"];
                      String quoteId = snapshot.data.docs[index].id;

                      return Slidable(
                        key: UniqueKey(),
                        endActionPane: ActionPane(
                          dismissible: DismissiblePane(
                            onDismissed: () async {
                              await FirebaseFirestore.instance.runTransaction(
                                  (Transaction myTransaction) async {
                                myTransaction.delete(
                                    snapshot.data.docs[index].reference);
                              });
                              await FirebaseStorage.instance
                                  .refFromURL(
                                      snapshot.data.docs[index]["imgUrl"])
                                  .delete();
                              // Remove this Slidable from the widget tree.
                            },
                          ),
                          motion: const DrawerMotion(),
                          extentRatio: 0.25,
                          children: [
                            SlidableAction(
                              label: 'Delete',
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                              onPressed: (context) {},
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuoteImage(
                                  content: content,
                                  imgUrl: snapshot.data.docs[index]["imgUrl"],
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
                                      image: NetworkImage(
                                          snapshot.data.docs[index]["imgUrl"]),
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
