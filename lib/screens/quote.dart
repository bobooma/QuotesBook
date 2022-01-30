import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/widgets/my_drawer.dart';
import 'package:my_quotes/widgets/translations_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_quotes/widgets/social_media.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuoteImage extends StatefulWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    required this.content,
    required this.docId,

    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;
  final String content;
  final String docId;

  @override
  State<QuoteImage> createState() => _QuoteImageState();
}

class _QuoteImageState extends State<QuoteImage> {
  Uint8List? captureImg;
  File? file;

  ScreenshotController screenshotController = ScreenshotController();

  _save() async {
    Navigator.of(context).pop();
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(widget.imgUrl,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name:
              "screenshot ${DateTime.now().toIso8601String().replaceAll(".", "_").replaceAll(":", "_")}");
    }
  }

  Future<void> shareFile() async {
    Navigator.of(context).pop();
    final url = Uri.parse(widget.imgUrl);
    final response = await get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/img.jpg";
    File(path).writeAsBytesSync(bytes);
    // ! revision
    Share.shareFiles([path], subject: widget.content, text: widget.content);
    print(widget.content);

    // await _save();
    // final result = await FilePicker.platform.pickFiles(
    //   allowMultiple: false,
    // );
    // if (result == null) return;
    // final path = result.files.single.path!;
    // setState(() => file = File(path));
  }

  screenCapture() async {
    await Permission.storage.request();
    final img = await screenshotController.capture();

    if (img == null) return;

    setState(() {
      captureImg = img;
    });

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(img),
        quality: 60, name: DateTime.now().toString());
    return result["filePath"];
  }

  Future<void> shareScreen() async {
    //  final path = await screenCapture();
    Navigator.of(context).pop();
    if (captureImg == null) {
      await screenCapture();
    }

    final dir = await getApplicationDocumentsDirectory();
    final img = File("${dir.path}/flutter.png");

    img.writeAsBytesSync(captureImg!);
    Share.shareFiles([img.path], subject: widget.content, text: widget.content);
    print(widget.content);
  }

  // IconData favIcon = Icons.favorite_border_outlined;

  bool isFav = false;

  toggleFav() {
    setState(() {
      isFav = !isFav;
      // favIcon = favIcon == Icons.favorite
      //     ? Icons.favorite_border_outlined
      //     : Icons.favorite;
    });
  }

  UserCredential? userCredential;
  String? userId;

  CollectionReference favorite =
      FirebaseFirestore.instance.collection("favorite");

  String newId = "";

  getId() async {
    userCredential = await FirebaseAuth.instance.signInAnonymously();

    userId = userCredential!.user!.uid;

    newId = "${widget.docId}$userId";

    var fav = await favorite.doc(newId).get().then((value) => value.exists);
    if (fav) {
      setState(() {
        isFav = true;
      });
    }
  }

  Future addRemoveUser() async {
    try {
      isFav
          ? favorite.doc(newId).delete()
          : favorite.doc(newId).set({
              "imgUrl": widget.imgUrl,
              "content": widget.content,
              "userId": userId,
              "time": Timestamp.now(),
            });
    } on Exception catch (e) {
      print(e);
    }

    toggleFav();

    // .add({"quoteId": widget.docId, "userId": useId});

    // FirebaseFirestore.instance
    //     .collection("favorite")
    //     .where("quoteId", isEqualTo: widget.docId);
  }

  @override
  void initState() {
    getId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final content = Provider.of<LocaleProvider>(context)
        .langeSwitch(widget.content, context);
    final lang = Provider.of<LocaleProvider>(context).locale.languageCode;
    return Scaffold(
      endDrawer: MyDrawer(
        imgUrl: widget.imgUrl,
        screenShare:
            Provider.of<LocaleProvider>(context).locale.languageCode == "en"
                ? shareFile
                : shareScreen,
        save: _save,
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: lang == "ar" || lang == "fa" || lang == "ur"
              ? Icon(Icons.arrow_back_ios_rounded)
              : Icon(Icons.arrow_back_ios_new),
        ),
        toolbarHeight: media.height * 0.05,
      ),
      // backgroundColor: Colors.pink[300],
      body: Provider.of<LocaleProvider>(context).locale.languageCode == "en"
          ? Column(
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                Expanded(
                  child: Image(
                    image: NetworkImage(
                      widget.imgUrl,
                    ),
                    // height: media.height * 0.9,
                    width: double.infinity,
                    //  MediaQuery.of(context).size.height * 1.4,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Container(
                  height: media.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          addRemoveUser();
                        },
                        icon: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.pink,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                )
                // SocialMedia(
                //   content: widget.content,
                //   height: media.height * 0.1,
                //   img: widget.imgUrl,
                // ),
              ],
            )
          : Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  FutureBuilder(
                    future: content,
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      return TranslationCard(
                        media: media,
                        data: snapshot.data ?? "",
                      );
                    },
                  ),
                  Expanded(
                    child: Image(
                      image: NetworkImage(
                        widget.imgUrl,
                      ),
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    height: media.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_border_outlined),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.share),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                  )
                ],
              ),
            ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(
      //       Icons.share,
      //       size: media.width * 0.05,
      //     ),
      //     onPressed: () {
      //       // ! user
      //       Share.share(
      //           "https://play.google.com/store/apps/details?id=com.DrHamaida.quotesBook");
      //     }),
    );
  }
}
