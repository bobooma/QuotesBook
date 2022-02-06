import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/providers/quote_model_provider.dart';
import 'package:my_quotes/widgets/my_drawer.dart';
import 'package:my_quotes/widgets/translations_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QuoteImage extends StatefulWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    required this.content,
    required this.docId,
    required this.index,
    required this.imgs,

    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;
  final String content;
  final String docId;
  final int index;
  final AsyncSnapshot imgs;

  @override
  State<QuoteImage> createState() => _QuoteImageState();
}

class _QuoteImageState extends State<QuoteImage> with TickerProviderStateMixin {
  Uint8List? captureImg;
  File? file;

  ScreenshotController screenshotController = ScreenshotController();

  late TransformationController controller;

  late AnimationController animationController;

  Animation<Matrix4>? animation;

  resetZoom() {
    animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity())
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward(from: 0);
  }

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

  // bool isFav = false;

  // toggleFav() {
  //   setState(() {
  //     isFav = !isFav;
  //     // favIcon = favIcon == Icons.favorite
  //     //     ? Icons.favorite_border_outlined
  //     //     : Icons.favorite;
  //   });

  // }

  UserCredential? userCredential;
  String? userId;

  CollectionReference favorite =
      FirebaseFirestore.instance.collection("favorite");

  String newId = "";

  getId() async {
    userCredential = await FirebaseAuth.instance.signInAnonymously();

    userId = userCredential!.user!.uid;

    var fav = await favorite
        .where("userId", isEqualTo: userId)
        .where("quoteId", isEqualTo: widget.docId)
        .get()
        .then((value) => value.docs.isNotEmpty);

    if (fav == true) {
      setState(() {
        Provider.of<QuoteModelProvider>(context, listen: false).isFavTrue();
      });
    }
  }

  Future addRemoveUser() async {
    try {
      if (Provider.of<QuoteModelProvider>(context, listen: false).isFav ==
          true) {
        favorite.get().then((value) {
          var fo = value.docs.firstWhere((element) {
            return element["userId"].toString() == userId &&
                element["quoteId"] == widget.docId;
          });
          fo.reference.delete();
        });

        // await favorite.doc(newId).delete();
        setState(() {
          Provider.of<QuoteModelProvider>(context, listen: false).isFavFalse();
        });
      } else {
        await favorite.doc().set({
          "imgUrl": widget.imgUrl,
          "content": widget.content,
          "userId": userId,
          "time": Timestamp.now(),
          "quoteId": widget.docId
        });
        setState(() {
          Provider.of<QuoteModelProvider>(context, listen: false).isFavTrue();
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  PageController? pgcontroller;

  @override
  void initState() {
    getId();

    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        controller.value = animation!.value;
      });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();

    super.dispose();
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
              ? const Icon(Icons.arrow_back_ios_rounded)
              : const Icon(Icons.arrow_back_ios_new),
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
                  child: PageView.builder(
                    controller: pgcontroller,
                    // allowImplicitScrolling: true,
                    itemCount: widget.imgs.data.docs.length,
                    itemBuilder: (context, i) {
                      int newLength =
                          widget.imgs.data.docs.length - widget.index;
                      int length = widget.imgs.data.docs.length;

                      return InteractiveViewer(
                        transformationController: controller,
                        maxScale: 7,
                        onInteractionEnd: (details) => resetZoom(),
                        child: CachedNetworkImage(
                            imageUrl: widget.imgs.data.docs[
                                (i + widget.index) > length - 1
                                    ? i - newLength
                                    : i + widget.index]["imgUrl"],
                            imageBuilder: (_, p) {
                              return Image(
                                image: p,
                                // height: media.height * 0.9,
                                width: double.infinity,
                                //  MediaQuery.of(context).size.height * 1.4,
                                fit: BoxFit.fitWidth,
                              );
                            }),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: media.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            addRemoveUser();
                          });
                        },
                        icon: Icon(
                          Provider.of<QuoteModelProvider>(context,
                                          listen: false)
                                      .isFav ==
                                  true
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.pink,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 50,
                )
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
                    child: PageView.builder(
                      itemCount: widget.imgs.data.docs.length,
                      itemBuilder: (context, i) {
                        return InteractiveViewer(
                          transformationController: controller,
                          maxScale: 7,
                          onInteractionEnd: (details) => resetZoom(),
                          child: CachedNetworkImage(
                              imageUrl: widget.imgs.data.docs[widget.index + i]
                                  ["imgUrl"],
                              imageBuilder: (_, p) {
                                return Image(
                                  image: p,
                                  // height: media.height * 0.9,
                                  width: double.infinity,
                                  //  MediaQuery.of(context).size.height * 1.4,
                                  fit: BoxFit.fill,
                                );
                              }),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: media.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              addRemoveUser();
                            });
                          },
                          icon: Icon(
                            Provider.of<QuoteModelProvider>(context,
                                            listen: false)
                                        .isFav ==
                                    true
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: Colors.pink,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
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
    );
  }
}
