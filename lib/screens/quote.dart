import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/providers/quote_model_provider.dart';
import 'package:my_quotes/services/utils.dart';
import 'package:my_quotes/widgets/my_drawer.dart';
import 'package:my_quotes/widgets/translations_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../services/ad_helper.dart';

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

  // final Future<String> content;
  String docId;
  String content;
  final int index;
  final AsyncSnapshot imgs;

  @override
  State<QuoteImage> createState() => _QuoteImageState();
}

class _QuoteImageState extends State<QuoteImage> with TickerProviderStateMixin {
  late BannerAd homeBanner;

  bool isHomeLoaded = false;

  void createHomeBanner() {
    homeBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdState.bannerhome,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              isHomeLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest());

    homeBanner.load();
  }

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

      const snackBar = SnackBar(
        content: Text("Image Was Saved Successfully"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> shareFile() async {
    // String content = await widget.content;
    Navigator.of(context).pop();
    final url = Uri.parse(widget.imgUrl);
    final response = await get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/img.jpg";
    File(path).writeAsBytesSync(bytes);
    // ! revision
    Share.shareFiles([path], subject: widget.content, text: widget.content);

    // await _save();
    // final result = await FilePicker.platform.pickFiles(
    //   allowMultiple: false,
    // );
    // if (result == null) return;
    // path = result.files.single.path!;
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
    // String content = await widget.content;
    //  final path = await screenCapture();
    if (captureImg == null) {
      await screenCapture();
    }

    final dir = await getApplicationDocumentsDirectory();
    final img = File("${dir.path}/flutter.png");

    img.writeAsBytesSync(captureImg!);
    Share.shareFiles([img.path], subject: widget.content, text: widget.content);
    // Navigator.of(context).pop();
  }

  UserCredential? userCredential;
  String? userId;

  CollectionReference favorite =
      FirebaseFirestore.instance.collection("favorite");

  // String newId = "";

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

  isFavFun(String newDocId) async {
    var fav = await favorite
        .where("userId", isEqualTo: userId)
        .where("quoteId", isEqualTo: newDocId)
        .get()
        .then((value) => value.docs.isNotEmpty);

    void setStateIfMounted(f) {
      if (mounted) setState(f);
    }

    if (fav == true) {
      setStateIfMounted(() {
        Provider.of<QuoteModelProvider>(context, listen: false).isFavTrue();
      });
    } else {
      setStateIfMounted(() {
        Provider.of<QuoteModelProvider>(context, listen: false).isFavFalse();
      });
    }
  }

  Future addRemoveUser(String img, String id, String content) async {
    try {
      if (Provider.of<QuoteModelProvider>(context, listen: false).isFav ==
          true) {
        favorite.get().then((value) {
          var fo = value.docs.firstWhere((element) {
            return element["userId"].toString() == userId &&
                element["quoteId"] == id;
          });
          fo.reference.delete();
        });

        // await favorite.doc(newId).delete();
        setState(() {
          Provider.of<QuoteModelProvider>(context, listen: false).isFavFalse();
        });
      } else {
        await favorite.doc().set({
          "imgUrl": img,
          "content": content,
          "userId": userId,
          "time": Timestamp.now(),
          "quoteId": id
        });
        setState(() {
          Provider.of<QuoteModelProvider>(context, listen: false).isFavTrue();
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  PageController? pgController;
  PageController? pgViewController;

  @override
  void initState() {
    getId();

    controller = TransformationController();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        controller.value = animation!.value;
      });
    createHomeBanner();

    super.initState();
    // getStr(widget.content);
  }

  // getStr(Future<String> content) async {
  //   await content.then((value) {
  //     setState(() {
  //       str = value;
  //     });
  //   });
  // }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    homeBanner.dispose();

    super.dispose();
  }

  Future<String> getLang(content) async {
    return await Provider.of<LocaleProvider>(context).langSwitch(
      content,
      context,
    );
  }

  var doc;
  late Size media;
  late String lang;
  late int newLength;
  late int length;
  // late Future<String> content2;
  late Future<String> content;

  String str = "";

  @override
  Widget build(BuildContext context) {
    // isFavFun();
    media = MediaQuery.of(context).size;
    // final content = getLang();

    final content = Provider.of<LocaleProvider>(context)
        .langSwitch(widget.content, context);
    lang = Provider.of<LocaleProvider>(context).locale.languageCode;
    return Scaffold(
        bottomNavigationBar: isHomeLoaded
            ? SizedBox(
                height: homeBanner.size.height.toDouble(),
                width: homeBanner.size.width.toDouble(),
                child: AdWidget(ad: homeBanner),
              )
            : null,
        backgroundColor: Colors.black,
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
        body: Provider.of<LocaleProvider>(context).locale.languageCode == "en"
            ? PageView.builder(
                controller: pgController,
                // allowImplicitScrolling: true,
                itemCount: widget.imgs.data.docs.length,
                itemBuilder: (context, i) {
                  newLength = widget.imgs.data.docs.length - widget.index;
                  length = widget.imgs.data.docs.length;

                  doc = widget.imgs.data.docs[(i + widget.index) > length - 1
                      ? i - newLength
                      : i + widget.index];

                  isFavFun(doc.id);

                  return Column(
                    children: [
                      Expanded(
                        child: InteractiveViewer(
                          transformationController: controller,
                          maxScale: 7,
                          onInteractionEnd: (details) => resetZoom(),
                          child: CachedNetworkImage(
                              imageUrl: doc["imgUrl"],
                              imageBuilder: (_, p) {
                                return Image(
                                  image: p,
                                  // height: media.height * 0.9,
                                  width: double.infinity,
                                  //  MediaQuery.of(context).size.height * 1.4,
                                  fit: BoxFit.fitWidth,
                                );
                              }),
                        ),
                      ),
                      // Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          height: media.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.docId = doc.id;

                                    addRemoveUser(
                                      doc["imgUrl"],
                                      doc.id,
                                      doc["content"],
                                    );
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
                                onPressed: () {
                                  Utils.shareFile(
                                      context, doc["imgUrl"], doc["content"]);
                                },
                                icon: const Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : Builder(builder: (context) {
                isFavFun(widget.docId);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 150,
                    //   child:
                    Screenshot(
                      controller: screenshotController,
                      child: Column(
                        children: [
                          FutureBuilder(
                              future: content,
                              builder:
                                  (context, AsyncSnapshot<String> snapshot) {
                                return TranslationCard(
                                    media: media,
                                    data: snapshot.data ?? widget.content);
                              }),
                          InteractiveViewer(
                            transformationController: controller,
                            maxScale: 7,
                            onInteractionEnd: (details) => resetZoom(),
                            child: CachedNetworkImage(
                                imageUrl: widget.imgUrl,
                                imageBuilder: (_, p) {
                                  return Image(
                                    image: p,
                                    // height: media.height * 0.9,
                                    width: double.infinity,
                                    //  MediaQuery.of(context).size.height * 1.4,
                                    fit: BoxFit.fill,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),

                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SizedBox(
                        height: media.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  // widget.docId = doc.id;

                                  addRemoveUser(widget.imgUrl, widget.docId,
                                      widget.content
                                      // getStr(widget.content)
                                      // doc["imgUrl"],
                                      // doc.id,
                                      // doc["content"],
                                      );
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
                              onPressed: () => shareScreen()
                              // getStr());
                              ,
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }));
  }
}
