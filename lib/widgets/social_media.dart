import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

enum Social { facebook, twitter, email, linkedin, whatsapp, instgram }

class SocialMedia extends StatefulWidget {
  final String img;
  final String content;

  SocialMedia({
    Key? key,
    required this.img,
    required this.height,
    required this.content,
  }) : super(key: key);

  final double height;

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  final String link = "";

  Future<String?> fetch(String img) async {
    var data = await MetadataFetch.extract(img);
    return data!.image;
  }

  Future<void> contact(Social platform) async {
    final urls = {
      Social.facebook:
          // "fb/@AmazPic7/",
          "https://www.facebook.com/AmazPic7/",
      // https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$txt
      // Social.twitter:
      //     "https://www.twitter.com/intent/tweet?url=$urlShare&t=$txt",
      // Social.email: "mailto:?subject=$subject&body=$txt\n\n$urlShare",
      // Social.linkedin:
      // "https://www.linkedin.com/shareArticle?mini=true&url=$urlShare",
      // Social.whatsapp: "https://www.api.whatsapp.com/send?text=$txt$urlShare",
      // Social.instgram: "https://www.api.whatsapp.com/send?text=$txt$urlShare",
    };
    final url = urls[platform]!;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    // String txt = " Share Everywhere $img";
    Future<String?> txt = fetch(widget.img);

    final media = MediaQuery.of(context).size;
    // final content =
    //     Provider.of<LocaleProvider>(context).langeSwitch(widget.content);

    return FutureBuilder(
      future: txt,
      builder: (context, AsyncSnapshot<String?> snapshot) => Container(
        width: double.infinity,
        height: media.height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.pleaseShare,
                  style: TextStyle(
                    fontFamily: "Rubik",
                    fontSize: media.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    // !!!  refresh link

                    final url = Uri.parse(widget.img);
                    final response = await get(url);
                    final bytes = response.bodyBytes;

                    final temp = await getTemporaryDirectory();
                    final path = "${temp.path}/img.jpg";
                    File(path).writeAsBytesSync(bytes);
                    // ! revision
                    Share.shareFiles([path],
                        subject: widget.content, text: widget.content);
                    print(widget.content);
                  },
                  icon: Icon(
                    Icons.share,
                    size: media.width * .06,
                    color: Colors.white,
                    semanticLabel: "Please Share ",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Row(
                    children: [
                      Text(
                        "Like My Page",
                        style: TextStyle(
                            fontSize: media.height * 0.025,
                            color: facebookColor,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        FontAwesomeIcons.facebookSquare,
                        color: facebookColor,
                      ),
                    ],
                  ),
                  onTap: () => contact(Social.facebook),
                )

                // Icon(
                //   FontAwesomeIcons.twitter,
                //   color: twittetColor,
                // ),
                // const SizedBox(
                //   width: 3,
                // ),
                // Icon(
                //   Icons.mail,
                //   color: mailColor,
                // ),
                // const SizedBox(
                //   width: 3,
                // ),
                // Icon(
                //   FontAwesomeIcons.linkedinIn,
                //   color: linkedinColor,
                // ),
                // const SizedBox(
                //   width: 3,
                // ),
                // Icon(
                //   FontAwesomeIcons.whatsapp,
                //   color: whatsappColor,
                // ),
                // Icon(
                //   FontAwesomeIcons.instagram,
                //   color: instgramColor,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
