import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/widgets/my_drawer.dart';
import 'package:my_quotes/widgets/translations_card.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_quotes/widgets/social_media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class QuoteImage extends StatefulWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    required this.content,

    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;
  final String content;

  @override
  State<QuoteImage> createState() => _QuoteImageState();
}

class _QuoteImageState extends State<QuoteImage> {
  File? file;

  _save() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(widget.imgUrl,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: DateTime.now().toString());
    }
  }

  Future<void> shareFile() async {
    await _save();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future<void> contact(Social platform) async {
    final urls = {
      Social.facebook:
          "https://www.facebook.com/profile.php?id=100005943935205",
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
    final media = MediaQuery.of(context).size;
    final content =
        Provider.of<LocaleProvider>(context).langeSwitch(widget.content);
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Container(
            height: media.height * 0.035,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 3,
                ),
                InkWell(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Contact Me",
                        style: TextStyle(
                            fontSize: media.width * .04, color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        FontAwesomeIcons.facebookMessenger,
                        color: facebookColor,
                        size: media.width * .045,
                      ),
                      Text(
                        " 😊",
                        style: TextStyle(
                            fontSize: media.width * .04, color: Colors.white),
                      ),
                    ],
                  ),
                  onTap: () => contact(Social.facebook),
                )
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(
                    fontFamily: "Rubik",
                    fontSize: media.width * .035,
                    fontWeight: FontWeight.bold,
                  ),

                  // ggg
                ),
                IconButton(
                  onPressed: _save,
                  icon: const Icon(Icons.download),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.pink[300],
        body: Provider.of<LocaleProvider>(context).locale.languageCode == "en"
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image(
                            image: NetworkImage(
                              widget.imgUrl,
                            ),
                            width: media.height * 0.7,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SocialMedia(
                    content: widget.content,
                    height: media.height * 0.1,
                    img: widget.imgUrl,
                  ),
                ],
              )
            : Column(
                children: [
                  Expanded(
                    child: Image(
                      image: NetworkImage(
                        widget.imgUrl,
                      ),
                      width: MediaQuery.of(context).size.height * 0.7,
                      fit: BoxFit.fill,
                    ),
                  ),
                  FutureBuilder(
                    future: content,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return Column(
                        children: [
                          TranslationCard(
                            media: media,
                            data: snapshot.data ?? "",
                          ),
                          SocialMedia(
                            content: snapshot.data ?? "",
                            height: media.height * 0.03,
                            img: widget.imgUrl,
                          ),
                        ],
                      );
                    },
                  )
                ],
              ));
  }
}
