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
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 3,
          right: 3,
        ),
        child: Center(
          child: Container(
            height: media.height * .14,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SelectableText(
                data,
                textAlign: TextAlign.center,
                style: TextStyle(
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
        ),
      ),
    );
  }
}
