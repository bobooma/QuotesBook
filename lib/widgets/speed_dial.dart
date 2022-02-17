import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_quotes/screens/make_quote.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/constants.dart';

class CustomSpeedDial extends StatelessWidget {
  const CustomSpeedDial({
    Key? key,
    required this.isDialOpen,
    required this.lang,
  }) : super(key: key);

  final ValueNotifier<bool> isDialOpen;
  final AppLocalizations lang;

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
      openCloseDial: isDialOpen,
      overlayColor: Colors.white10,
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 40),
      children: [
        SpeedDialChild(
            backgroundColor: kPrimaryColor300,
            child: const Icon(
              Icons.app_registration_outlined,
              size: 40,
            ),
            label: lang.myApps,
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
            label: lang.shareApp,
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
            label: lang.makeQuote,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MakeQuote()));
            }),
      ],
    );
  }
}
