import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:my_quotes/constants.dart';
import 'package:my_quotes/providers/themes.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'language_picker_widget.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key? key,
    required this.shareApp,
  }) : super(key: key);

  final VoidCallback shareApp;

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  File? file;

  Future<void> contact(String url, BuildContext context) async {
    Navigator.of(context).pop();

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    final appLoc = AppLocalizations.of(context);
    return MultiLevelDrawer(
        // itemHeight: media.width * 0.1,
        header: Container(),
        gradient: !Provider.of<ThemeProvider>(context).isDarkMode
            ? LinearGradient(colors: [
                kPrimaryColor.shade400,
                Colors.white,
              ])
            : LinearGradient(colors: [
                kPrimaryColor.shade400,
                Colors.black,
              ]),
        children: [
          // mLMitem(media, "${AppLocalizations.of(context)!.changeTheme} 🔲", Icons.change_circle_outlined, !Provider.of<ThemeProvider>(context).isDarkMode
          //         ? Colors.black
          //         : Colors.white,()=> const ChangeTheme(),),

          mLMitem(
              media,
              "${AppLocalizations.of(context)!.changeTheme} 💥",
              Icons.color_lens,
              kSecondaryColor,
              () => provider.toggleTheme(themeProvider.isDarkMode)
              //  const ChangeTheme()
              ),
          MMLLang(appLoc, media),
          // ! SHARE APP
          mLMitem(media, "${AppLocalizations.of(context)!.share} ✅",
              Icons.share, kSecondaryColor, widget.shareApp),

          mLMitem(
              media,
              "${AppLocalizations.of(context)!.contactMe} 😊",
              Icons.facebook_sharp,
              facebookColor,
              () => contact(myFBAccount, context)),
          mLMitem(media, "${AppLocalizations.of(context)!.myWebsite} 👌",
              Icons.web, Colors.greenAccent, () => contact(myWeb, context)),
          mLMitem(
              media,
              "${AppLocalizations.of(context)!.youtubeChannel} 🎦",
              Icons.video_collection,
              Colors.deepOrange,
              () => contact(myChannel, context)),
          mLMitem(
              media,
              "${AppLocalizations.of(context)!.myVideospage}  ⏩",
              Icons.video_library_sharp,
              Colors.purple,
              () => contact(myVideosPg, context)),
          mLMitem(
              media,
              "${AppLocalizations.of(context)!.telegramChanel} 📠",
              Icons.send_and_archive_sharp,
              Colors.blueAccent.shade200,
              () => contact(mytelegramChannel, context)),
          MLMenuItem(content: const Text(""), onClick: () {})
        ]);
  }

  MLMenuItem MMLLang(AppLocalizations? appLoc, Size media) {
    return MLMenuItem(
      onClick: () {
        // LangPickWidget();
      },
      content: FittedBox(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            appLoc!.chooseLanguage,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontFamily: "LimeLihgt"),
          ),
        ),
      ),
      trailing: const LangPickWidget(),
//
//       ),
    );
  }

  MLMenuItem mLMitem(
      Size media, String txt, IconData icn, Color clr, VoidCallback fun) {
    return MLMenuItem(
      onClick: () async {
        await fun();
        // Navigator.of(context).pop();
      },
      trailing: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Icon(
            icn,
            size: media.width * .04,
            color: clr,
          ),
        ],
      ),
      content: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const SizedBox(
            //   width: 5,
            // ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              // color: Colors.black54,
              child: Text(
                txt,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    // fontSize: media.width * 0.02,

                    fontFamily: "LimeLihgt"),
                //  whiteSty(media.width * .02, "Limelight"),
              ),
            ),
            // const SizedBox(
            //   width: 5,
            // ),
          ],
        ),
      ),
    );
  }
}
