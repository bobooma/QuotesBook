import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_quotes/screens/quote.dart';

import '../services/ad_helper.dart';

const int maxFailedLoadAttempt = 3;

class Sliders extends StatefulWidget {
  const Sliders({
    Key? key,
    required this.imgs,
  }) : super(key: key);

  final AsyncSnapshot imgs;
  // final Future<String> content;

  @override
  State<Sliders> createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  InterstitialAd? interstitialAd;
  int interstatilLoadAttempt = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdState.interstatialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          interstatilLoadAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstatilLoadAttempt += 1;
          interstitialAd = null;
          if (interstatilLoadAttempt >= maxFailedLoadAttempt) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      interstitialAd!.show();
    }
  }

  @override
  void initState() {
    _createInterstitialAd();
    super.initState();

    // getStr(widget.content);
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  // String str = "";
  // getStr(Future<String> content) async {
  //   await content.then((value) {
  //     setState(() {
  //       str = value;
  //     });
  //   });
  // }
  double width = 0;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return widget.imgs == null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          )
        : Center(
            child: CarouselSlider.builder(
                itemCount: widget.imgs.data.docs.length,
                itemBuilder: (ctx, i, _) {
                  return InkWell(
                    onTap: () {
                      // getStr(widget.imgs.data.docs[i]["content"]);
                      _showInterstitialAd();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuoteImage(
                            imgUrl: widget.imgs.data.docs[i]["imgUrl"],
                            content: widget.imgs.data.docs[i]["content"],
                            docId: widget.imgs.data.docs[i].id,
                            index: i,
                            imgs: widget.imgs,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.imgs.data.docs[i]["imgUrl"],
                      imageBuilder: (_, p) {
                        return Container(
                          margin: const EdgeInsets.all(1),
                          // width: width / 3,
                          height: height / 2,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 3.0, offset: Offset(0.0, 2)),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: p, fit: BoxFit.fill),
                          ),
                        );
                      },
                      progressIndicatorBuilder: (context, url, progress) {
                        return Container(
                          width: width / 2,
                          height: height / 2,
                          color: Colors.grey.withOpacity(.4),
                          child: const Center(
                              child: SpinKitThreeBounce(
                                  size: 30, color: Colors.pink)),
                        );
                      },
                    ),
                  );
                },
                options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    viewportFraction: 0.3,
                    // enlargeStrategy: CenterPageEnlargeStrategy.height,

                    enlargeCenterPage: true,
                    autoPlayInterval: const Duration(seconds: 2))),
          );
  }
}
