import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';

enum Social { facebook, twitter, email, linkedin, whatsapp }

class SocialMedia extends StatefulWidget {
  final String img;
  final NetworkImage networkImage;

  SocialMedia({
    Key? key,
    required this.img,
    required this.networkImage,
  }) : super(key: key);

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  Future<String?> fetch(String img) async {
    var data = await MetadataFetch.extract(img);
    return data!.image;
  }

  @override
  Widget build(BuildContext context) {
    // String txt = " Share Everywhere $img";
    Future<String?> txt = fetch(widget.img);

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
                  onPressed: () async {
                    // !!!  refresh link

                    final url = Uri.parse(widget.img);
                    final response = await get(url);
                    final bytes = response.bodyBytes;

                    final temp = await getTemporaryDirectory();
                    final path = "${temp.path}/img.jpg";
                    File(path).writeAsBytesSync(bytes);
                    // ! revision
                    Share.shareFiles([path], text: "الحمد لله");
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
