import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TranslationCard extends StatelessWidget {
  const TranslationCard({
    Key? key,
    required this.media,
    required this.data,
  }) : super(key: key);

  final Size media;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20, right: 5, left: 5),
          color: Colors.white,
          height: media.height * .15,
          child: AutoSizeText(
            (data),
            textAlign: TextAlign.center,
            maxLines: 5,
            minFontSize: 8,
            // maxFontSize: 50,
            style: TextStyle(
              // overflow: TextOverflow.visible,
              //
              // ***
              // TODO rEVISION
              //overflow: TextOverflow.ellipsis,
              fontSize: media.width * .04,
              fontWeight: FontWeight.bold,

              // letterSpacing: 2,
              fontFamily: "RobotoCondensed",
            ),
          ),
        ),
      ),
    );
  }
}
