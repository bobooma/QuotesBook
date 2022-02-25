import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

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
          onTap: () async {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => StoriesEditor(
            //       giphyKey: '[HERE YOUR API KEY]',
            //       //fontFamilyList: ['Shizuru'],
            //       //isCustomFontList: true,
            //       onDone: (uri) {
            //         debugPrint(uri);
            //         Share.shareFiles([uri]);
            //       },
            //     ),
            //   ),
            // );

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

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => MakeQuote()
            //       //  MakeQuote()
            //       ),
            // );
          },
        ),
      ],
    );
  }
}
