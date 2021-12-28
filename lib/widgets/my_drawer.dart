import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:multilevel_drawer/multilevel_drawer.dart';
import 'package:my_quotes/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'language_picker_widget.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer(
      {Key? key,
      required this.imgUrl,
      required this.screenShare,
      required this.save})
      : super(key: key);

  final String imgUrl;
  final VoidCallback screenShare;
  final VoidCallback save;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  File? file;

  Future<void> contact(String url, BuildContext context) async {
    Navigator.of(context).pop();
    // final urls = {
    //   "facebook": "https://www.facebook.com/profile.php?id=100005943935205",
    // };

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // _save() async {
  //   var status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     var response = await Dio().get(widget.imgUrl,
  //         options: Options(responseType: ResponseType.bytes));
  //     final result = await ImageGallerySaver.saveImage(
  //         Uint8List.fromList(response.data),
  //         quality: 60,
  //         name: DateTime.now().toString());
  //   }
  // }

  // Future<void> shareFile() async {
  //   await _save();
  //   final result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //   );
  //   if (result == null) return;
  //   final path = result.files.single.path!;
  //   setState(() => file = File(path));
  // }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    final appLoc = AppLocalizations.of(context);
    const padd = EdgeInsets.symmetric(horizontal: 20);
    return MultiLevelDrawer(
        // itemHeight: media.width * 0.1,
        header: Container(),
        gradient: LinearGradient(colors: [
          Colors.white.withOpacity(0.5),
          Colors.pink.shade300,
        ]),
        children: [
          MMLLang(appLoc, media),
          mLMitem(media, "${AppLocalizations.of(context)!.share} ♾",
              Icons.share, Colors.white, widget.screenShare),
          mLMitem(media, "${AppLocalizations.of(context)!.save} ⏬",
              Icons.download, Colors.black, widget.save),
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
          MLMenuItem(content: Text(""), onClick: () {})
        ]);
  }

  MLMenuItem MMLLang(AppLocalizations? appLoc, Size media) {
    return MLMenuItem(
      onClick: () {
        // LangPickWidget();
      },
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            color: Colors.black45,
            child: Text(
              appLoc!.chooseLanguage,

              style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: media.width * 0.03,
                  fontWeight: FontWeight.bold,
                  fontFamily: "LimeLihgt"),
              //  TextStyle(
              //     fontSize: media.width * .03,
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //     fontFamily: "LimeLihgt")
              // media.width * .035,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.language,
            color: Colors.black,
            size: media.width * .04,
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
    );
  }

  MLMenuItem mLMitem(
      Size media, String txt, IconData icn, Color clr, VoidCallback fun) {
    return MLMenuItem(
      onClick: () async {
        await fun();
        // Navigator.of(context).pop();
      },
      content: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const SizedBox(
            //   width: 5,
            // ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              // color: Colors.black54,
              child: Text(
                txt,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontSize: media.width * 0.02, fontFamily: "LimeLihgt"),
                //  whiteSty(media.width * .02, "Limelight"),
              ),
            ),
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
      ),
    );
  }
}
