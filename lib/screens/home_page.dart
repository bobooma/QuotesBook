import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_quotes/screens/quote.dart';

import '../services/utils.dart';
import '../services/ad_helper.dart';
import '../widgets/carousal_screen.dart';
import '../widgets/my_card.dart';
import 'my_home.dart';

// const int maxFailedLoadAttempt = 3;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  UserCredential? userCredential;

  getUserId() async {
    userCredential = await FirebaseAuth.instance.signInAnonymously();
    userId = userCredential!.user!.uid;
  }

  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .orderBy("time", descending: true)
      .snapshots();

  initialMessage() async {
    final message = FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MyHomePage(),
          ));
    }
  }

  Locale? locale;

  final inlineIndex = 3;

  late BannerAd homeBanner;
  late BannerAd inlineBanner;

  bool isHomeLoaded = false;
  bool isInlineLoaded = false;

  late String quoteId;
  late Future<String> content;

  int getListvItemIndx(int index) {
    if (index >= inlineIndex && isInlineLoaded) {
      return index - 1;
    } else {
      return index;
    }
  }

  void createHomeBanner() {
    try {
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
    } on Exception catch (e) {
      print("homeBanner  error $e");
    }
  }

  void createInlineBanner() {
    try {
      inlineBanner = BannerAd(
          size: AdSize.mediumRectangle,
          adUnitId: AdState.inline,
          listener: BannerAdListener(
            onAdLoaded: (_) {
              setState(() {
                isInlineLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            },
          ),
          request: const AdRequest());

      inlineBanner.load();
    } on Exception catch (e) {
      print("homeInline  error $e");
    }
  }

  @override
  void initState() {
    getUserId();
    // LocalNotificationService.initialize(context);
    FirebaseMessaging.onMessage.listen((message) {
      // LocalNotificationService.display(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    Utils.getToken();

    createHomeBanner();
    // _createInterstitialAd();
    createInlineBanner();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    homeBanner.dispose();
    // interstitialAd?.dispose();
    inlineBanner.dispose();
  }

  double width = 0;
  double height = 0;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: isHomeLoaded
          ? SizedBox(
              height: homeBanner.size.height.toDouble(),
              width: homeBanner.size.width.toDouble(),
              child: AdWidget(ad: homeBanner),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: quotes,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text('error .....');
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: height * 0.58,
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length +
                            (isInlineLoaded ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (isInlineLoaded && index == inlineIndex) {
                            return Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              width: inlineBanner.size.width.toDouble(),
                              height: inlineBanner.size.height.toDouble(),
                              child: AdWidget(ad: inlineBanner),
                            );
                          } else {
                            String content = snapshot
                                .data.docs[getListvItemIndx(index)]["content"];

                            String quoteId =
                                snapshot.data.docs[getListvItemIndx(index)].id;

                            return Slidable(
                              key: UniqueKey(),
                              endActionPane: ActionPane(
                                dismissible: DismissiblePane(
                                  onDismissed: ()
                                      // async
                                      {},
                                ),
                                motion: const DrawerMotion(),
                                extentRatio: 0.25,
                                children: [
                                  SlidableAction(
                                    label: 'Download',
                                    backgroundColor: Colors.amber,
                                    icon: Icons.download,
                                    onPressed: (context) {
                                      Utils.save(
                                          snapshot.data
                                                  .docs[getListvItemIndx(index)]
                                              ["imgUrl"],
                                          context);
                                    },
                                  ),

                                  // !  Admin
                                  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                                  // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  try {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuoteImage(
                                          content: content,
                                          imgUrl: snapshot.data
                                                  .docs[getListvItemIndx(index)]
                                              ["imgUrl"],
                                          docId: quoteId,
                                          index: getListvItemIndx(index),
                                          imgs: snapshot,
                                        ),
                                      ),
                                    );
                                  } on Exception catch (e) {
                                    print(e.toString());
                                    // TODO
                                  }
                                },
                                child: SizedBox(
                                  width: width,
                                  height: height * 0.2,
                                  child: Stack(children: [
                                    Positioned(
                                      child: MyCard(details: content),
                                    ),
                                    Positioned(
                                      top: 5,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data
                                                .docs[getListvItemIndx(index)]
                                            ["imgUrl"],
                                        imageBuilder: (_, p) {
                                          return Container(
                                            height: height * 0.2,
                                            width: height * 0.2,
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(blurRadius: 2)
                                              ],
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover, image: p),
                                            ),
                                          );
                                        },
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return Container(
                                            width: width / 2,
                                            height: height / 2,
                                            color: Colors.grey.withOpacity(.4),
                                            child: const Center(
                                                child: SpinKitThreeBounce(
                                                    size: 30,
                                                    color: Colors.pink)),
                                          );
                                        },
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ),
                SizedBox(
                    height: height * 0.15,
                    child: Sliders(
                      imgs: snapshot,
                      // content: str,
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
