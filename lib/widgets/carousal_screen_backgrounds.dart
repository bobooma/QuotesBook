import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_helper.dart';

const int maxFailedLoadAttempt = 3;

class BackgroundSliders extends StatefulWidget {
  const BackgroundSliders({
    Key? key,
    required this.imgs,
  }) : super(key: key);

  final AsyncSnapshot imgs;

  @override
  State<BackgroundSliders> createState() => _BackgroundSlidersState();
}

class _BackgroundSlidersState extends State<BackgroundSliders> {
  late BannerAd inlineBanner;

  final inlineIndex = 3;
  bool isInlineLoaded = false;

  int getListvItemIndx(int index) {
    if (index >= inlineIndex && isInlineLoaded) {
      return index - 1;
    } else {
      return index;
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
      print(e.toString());
    }
  }

  InterstitialAd? interstitialAd;
  int interstitialLoadAttempt = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdState.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          interstitialLoadAttempt = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          interstitialLoadAttempt += 1;
          interstitialAd = null;
          if (interstitialLoadAttempt >= maxFailedLoadAttempt) {
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
    createInlineBanner();
    super.initState();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    inlineBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return widget.imgs == null
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            ),
          )
        : Expanded(
            child: Center(
              child: CarouselSlider.builder(
                  itemCount: widget.imgs.data.docs.length +
                      (isInlineLoaded && widget.imgs.data.docs.length >= 3
                          ? 1
                          : 0),
                  itemBuilder: (ctx, i, _) {
                    if (isInlineLoaded && i == inlineIndex) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: inlineBanner.size.width.toDouble(),
                        height: inlineBanner.size.height.toDouble(),
                        child: AdWidget(ad: inlineBanner),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          _showInterstitialAd();
                          Navigator.of(context).pop(
                              widget.imgs.data.docs[getListvItemIndx(i)]["b"]);
                        },
                        child: CachedNetworkImage(
                          imageUrl: widget.imgs.data.docs[getListvItemIndx(i)]
                              ["b"],
                          imageBuilder: (_, p) {
                            return Container(
                              margin: const EdgeInsets.all(1),
                              // width: width / 3,
                              height: height / 2,
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 3.0,
                                        offset: Offset(0.0, 2)),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: p, fit: BoxFit.fill)),
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
                    }
                  },
                  options: CarouselOptions(
                      height: 600,
                      autoPlay: true,
                      viewportFraction: 0.7,
                      // enlargeStrategy: CenterPageEnlargeStrategy.height,

                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 2))),
            ),
          );
  }
}
