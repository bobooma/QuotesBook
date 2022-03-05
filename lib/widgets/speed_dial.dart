import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:my_quotes/widgets/upload_screen.dart';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_helper.dart';

const int maxFailedLoadAttempt = 3;

class CustomSpeedDial extends StatefulWidget {
  const CustomSpeedDial({
    Key? key,
    required this.isDialOpen,
    required this.lang,
  }) : super(key: key);

  final ValueNotifier<bool> isDialOpen;
  final AppLocalizations lang;

  @override
  State<CustomSpeedDial> createState() => _CustomSpeedDialState();
}

class _CustomSpeedDialState extends State<CustomSpeedDial> {
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
    super.initState();
  }

  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> launchApp() async {
    const url =
        "https://play.google.com/store/apps/details?id=com.DrHamaida.my_bmi";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      openCloseDial: widget.isDialOpen,
      overlayColor: Colors.white10,
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 40),
      children: [
        SpeedDialChild(
            backgroundColor: kPrimaryColor300,
            child: const Icon(
              Icons.update,
              size: 40,
            ),
            label: "upload",
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UploadScreen()));
            }),
        SpeedDialChild(
            backgroundColor: kPrimaryColor300,
            child: const Icon(
              Icons.app_registration_outlined,
              size: 40,
            ),
            label: widget.lang.myApps,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              launchApp();
            }),
        SpeedDialChild(
            backgroundColor: kPrimaryColor300,
            child: const Icon(
              Icons.share,
              size: 40,
            ),
            label: widget.lang.shareApp,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Share.share(
                  "https://play.google.com/store/apps/details?id=com.DrHamaida.QuotesBook");
            }),
        SpeedDialChild(
          backgroundColor: kPrimaryColor300,
          child: const Icon(
            Icons.imagesearch_roller,
            size: 40,
          ),
          label: widget.lang.makeQuote,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: () async {
            _showInterstitialAd();

            final ByteData bytes =
                await rootBundle.load("assets/ic_launcher.png");
            final Uint8List list = bytes.buffer.asUint8List();
            try {
              final editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: Uint8List.fromList(list), // <-- Uint8List of image
                    appBarColor: Colors.purple,
                    bottomBarColor: Colors.purple,
                  ),
                ),
              );
            } on Exception catch (e) {
              debugPrint(e.toString());
              // TODO
            }
          },
        ),
      ],
    );
  }
}
