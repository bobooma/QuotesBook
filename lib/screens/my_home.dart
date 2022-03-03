import 'package:flutter/material.dart';
import 'package:my_quotes/providers/locale_provider.dart';

import 'package:my_quotes/screens/fav_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:my_quotes/services/constants.dart';

import 'package:my_quotes/widgets/change_theme.dart';
import 'package:my_quotes/widgets/home_drawer.dart';
import 'package:my_quotes/widgets/speed_dial.dart';
import 'package:provider/provider.dart';

import '../services/themes.dart';
import 'blessings.dart';
import 'funny_pg.dart';
import 'health.dart';
import 'home_page.dart';
import 'inspiration.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  final isDialOpen = ValueNotifier(false);

  late Size media;
  late AppLocalizations lang;
  late String lang2;

  TextStyle? theme;

  late bool themeMode;

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;

    lang = AppLocalizations.of(context)!;
    lang2 = Provider.of<LocaleProvider>(context).locale.languageCode;
    theme = Theme.of(context).textTheme.bodyLarge;

    themeMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

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
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  titleSpacing: 0,
                  flexibleSpace: !themeMode
                      ? customGradientShader(
                          img: const AssetImage(
                              "assets/WhatsApp Image 2022-02-28 at 12.19.13 PM.jpeg"),
                          clr1: kPrimaryColor.withBlue(255),
                          clr2: Colors.white,
                          blend: BlendMode.dstOver)
                      : customGradientShader(
                          img: const AssetImage(
                              "assets/WhatsApp Image 2022-02-28 at 12.19.13 PM.jpeg"),
                          clr1: Colors.black87,
                          clr2: kPrimaryColor.withRed(255).withAlpha(60),
                          blend: BlendMode.multiply),
                  bottom: TabBar(isScrollable: true, tabs: [
                    Tab(
                      icon: Icon(
                        Icons.home,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    Tab(
                      child: Text(lang.funny, style: theme),
                    ),
                    Tab(
                      child: Text(
                        lang.favorites,
                        style: theme,
                      ),
                    ),
                    Tab(
                      child: Text(
                        lang.health,
                        style: theme,
                      ),
                    ),
                    Tab(
                      child: Text(
                        lang.inspiring,
                        style: theme,
                      ),
                    ),
                    Tab(
                      child: Text(
                        lang.blessings,
                        style: theme,
                      ),
                    ),
                  ]),
                  toolbarHeight: media.height * 0.07,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: media.width * .35,
                        child: CustomHeader(themeMode: themeMode, media: media),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.newQuote,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  fontFamily: "RobotoCondensed",
                                  fontSize: media.width * .032,
                                  fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  actions: const [
                    ChangeTheme()

                    //
                  ],
                )
              ];
            },
            body: TabBarView(
              children: [
                HomePage(),
                FunnyPage(),
                const FavScreen(),
                HealthScreen(),
                Inspiration(),
                Blessings(),
              ],
            ),
          ),
          drawer: HomeDrawer(),
        ),
      ),
    );
  }

  ShaderMask customGradientShader(
      {required Color clr1,
      required Color clr2,
      required BlendMode blend,
      required ImageProvider img}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [clr1, clr2],
        // stops: const [0.5, 0.7],
        // begin: Alignment.topCenter, end: Alignment.bottomCenter
      ).createShader(bounds),
      blendMode: blend,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: img,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key? key,
    required this.themeMode,
    required this.media,
  }) : super(key: key);

  final bool themeMode;
  final Size media;

  @override
  Widget build(BuildContext context) {
    return !themeMode
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
                    fontFamily: "Limelight",
                    fontSize: media.width * .045,
                    fontWeight: FontWeight.bold),
              ),
            ))
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(colors: [
                  kPrimaryColor.withBlue(255),
                  Colors.black12,
                ])),
            child: FittedBox(
              child: Text(
                'QuotesBook',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontFamily: "Limelight",
                    fontSize: media.width * .045,
                    fontWeight: FontWeight.bold),
              ),
            ));
  }
}
