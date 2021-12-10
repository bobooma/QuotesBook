import 'package:flutter/material.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:my_quotes/constants.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_picker_widget.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  Future<void> contact(String url) async {
    // Navigator.of(context).pop();
    // final urls = {
    //   "facebook": "https://www.facebook.com/profile.php?id=100005943935205",
    // };

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final appLoc = AppLocalizations.of(context);
    const padd = EdgeInsets.symmetric(horizontal: 20);
    return MultiLevelDrawer(
        // itemHeight: media.width * 0.1,
        header: Container(),
        gradient: LinearGradient(
            colors: [instgramColor, Colors.white.withOpacity(0.5)]),
        children: [
          MLMenuItem(
            onClick: () {
              // LangPickWidget();
            },
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.black45,
                  child: Text(
                    appLoc!.chooseLanguage,
                    style: whiteSty(
                        media.width * .035,
                        // media.width * .035,
                        "Lobster"),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.language,
                  color: Colors.black54,
                  size: media.width * .05,
                ),
              ],
            ),
            trailing: Row(
              children: const [
                SizedBox(
                  width: 5,
                ),
                LangPickWidget(),
              ],
            ),
          ),
          mLMitem(media, "Contact Me 😊", Icons.facebook_sharp, facebookColor,
              () => contact(myFBAccount)),
          mLMitem(media, "Like My page ", Icons.favorite, Colors.red,
              () => contact(myFBPage)),
          MLMenuItem(content: Text(""), onClick: () {})
        ]);
  }

  MLMenuItem mLMitem(
      Size media, String txt, IconData icn, Color clr, VoidCallback fun) {
    return MLMenuItem(
      onClick: fun,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(
          //   width: 5,
          // ),
          Container(
            color: Colors.black54,
            child: Text(
              txt,
              style: whiteSty(media.width * .035, "Limelight"),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            icn,
            size: media.width * .05,
            color: clr,
          ),
        ],
      ),
    );
  }
}
