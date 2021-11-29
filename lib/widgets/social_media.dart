import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';

enum Social { facebook, twitter, email, linkedin, whatsapp }

class SocialMedia extends StatelessWidget {
  final String img;
  final NetworkImage networkImage;

  SocialMedia({
    Key? key,
    required this.img,
    required this.networkImage,
  }) : super(key: key);

  Future<String?> fetch(String img) async {
    var data = await MetadataFetch.extract(img);
    return data!.image;
  }

// ****

  // Future<void> share(Social platform) async {
  //   const subject = " share everywhere  myQuotes";

  //   final urlShare = Uri.encodeComponent(img);
  //   final urls = {
  //     Social.facebook:
  //         "https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$txt",
  //     Social.twitter:
  //         "https://www.twitter.com/intent/tweet?url=$urlShare&t=$txt",
  //     Social.email: "mailto:?subject=$subject&body=$txt\n\n$urlShare",
  //     Social.linkedin:
  //         "https://www.linkedin.com/shareArticle?mini=true&url=$urlShare",
  //     Social.whatsapp: "https://www.api.whatsapp.com/send?text=$txt$urlShare",
  //   };
  //   final url = urls[platform]!;
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // String txt = " Share Everywhere $img";
    Future<String?> txt = fetch(img);

    return FutureBuilder(
      future: txt,
      builder: (context, AsyncSnapshot<String?> snapshot) => Container(
        width: double.infinity,
        height: 80,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.pleaseShare,
                  style: const TextStyle(
                    fontFamily: "Rubik",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: ()

                      // !!!  refresh link

                      {
                    Share.share(snapshot.data ?? "");
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                    semanticLabel: "Please Share",
                    size: 30,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.facebookSquare,
                  color: facebookColor,
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  FontAwesomeIcons.twitter,
                  color: twittetColor,
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  Icons.mail,
                  color: mailColor,
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  FontAwesomeIcons.linkedinIn,
                  color: linkedinColor,
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  FontAwesomeIcons.whatsapp,
                  color: whatsappColor,
                ),
                Icon(
                  FontAwesomeIcons.instagram,
                  color: instgramColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
