import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_quotes/services/ad_helper.dart';
import 'package:my_quotes/widgets/carousal_screen_backgrounds.dart';

class Backgrounds extends StatefulWidget {
  const Backgrounds({Key? key}) : super(key: key);

  @override
  State<Backgrounds> createState() => _BackgroundsState();
}

class _BackgroundsState extends State<Backgrounds> {
  final backgrounds =
      FirebaseFirestore.instance.collection("backgrounds").snapshots();

  late BannerAd homeBanner;

  bool isHomeLoaded = false;

  void createHomeBanner() {
    try {
      homeBanner = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState.bannerBackGround,
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
      print("home error $e");
    }
  }

  @override
  void initState() {
    createHomeBanner();

    super.initState();
  }

  @override
  void dispose() {
    homeBanner.dispose();
    super.dispose();
    // interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isHomeLoaded
          ? SizedBox(
              height: homeBanner.size.height.toDouble(),
              width: homeBanner.size.width.toDouble(),
              child: AdWidget(ad: homeBanner),
            )
          : null,
      body: StreamBuilder(
        stream: backgrounds,
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: BackgroundSliders(
              imgs: snapshot,
            ),
          );
        },
      ),
    );
  }
}
