import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/providers/locale_provider.dart';

import 'package:my_quotes/screens/fav_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_quotes/services/constants.dart';

import 'package:my_quotes/widgets/change_theme.dart';
import 'package:my_quotes/widgets/home_drawer.dart';
import 'package:my_quotes/widgets/speed_dial.dart';
import 'package:provider/provider.dart';

import '../providers/utils.dart';
import '../services/themes.dart';
import 'blessings.dart';
import 'funny_pg.dart';
import 'health.dart';
import 'home_page.dart';
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

  initialMessage() async {
    final message = FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MyHomePage(),
          ));
    }
  }

  @override
  void initState() {
    getUserId();
    // LocalNotificationService.initialize(context);
    FirebaseMessaging.onMessage.listen((message) {
      // LocalNotificationService.display(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    Utils.getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final lang = AppLocalizations.of(context)!;
    final lang2 = Provider.of<LocaleProvider>(context).locale.languageCode;
    final theme = Theme.of(context).textTheme.headline6;

    bool thememode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

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
          drawer: const HomeDrawer(),
          appBar: AppBar(
            titleSpacing: 0,
            flexibleSpace: !thememode
                ? Container(
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(colors: [
                      Colors.white60,
                      kPrimaryColor.withBlue(255)
                    ])),
                  )
                : Container(
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                      colors: [Colors.black54, kPrimaryColor.withRed(255)],
                    )),
                  ),
            bottom: TabBar(isScrollable: true, tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              Tab(
                child: Text(lang.funny, style: theme
                    //  const TextStyle(fontWeight: FontWeight.bold),
                    ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.favorites,
                  style: theme,
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.health,
                  style: theme,
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.inspiring,
                  style: theme,
                ),
              ),
              Tab(
                // icon: Icon(Icons.fu),
                child: Text(
                  lang.blessings,
                  style: theme,
                ),
              ),
            ]),
            // !!!!!!!!!!!AMIN
            toolbarHeight: media.height * 0.08,
            // !!!!!!!!!!!!user
            // toolbarHeight: media.height * 0.05,

            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: media.width * .35,
                  child: CustomHeader(thememode: thememode, media: media),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.newQuote,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontFamily: "RobotoCondensed",
                        fontSize: media.width * .032,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            actions: [
              Column(
                children: const [
                  Expanded(child: ChangeTheme()),
                ],
              )

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
              const FavScreen(),
              HealthScreen(),
              Inspiration(),
              Blessings(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key? key,
    required this.thememode,
    required this.media,
  }) : super(key: key);

  final bool thememode;
  final Size media;

  @override
  Widget build(BuildContext context) {
    return !thememode
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(colors: [
                  Colors.white70,
                  kPrimaryColor,
                ])),
            child: FittedBox(
              child: Text(
                'QuotesBook',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontFamily: "Lobster",
                      fontSize: media.width * .04,
                    ),
              ),
            ))
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                    colors: [Colors.black45, kPrimaryColor.withRed(255)])),
            child: FittedBox(
              child: Text(
                'QuotesBook',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontFamily: "Lobster",
                      fontSize: media.width * .04,
                    ),
              ),
            ));
  }
}
