import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_quotes/widgets/social_media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuoteImage extends StatelessWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    required this.networkImage,
    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;
  final NetworkImage networkImage;

  // String url =
  //     "https://image.freepik.com/free-vector/powder-holi-paints-frame-border-solated_1441-3793.jpg";

  _save() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: DateTime.now().toString());
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isLarge = MediaQuery.of(context).size.width >= 600;

    // if (isLarge) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       actions: [
    //
    // )
    //       ],
    //     ),
    //     backgroundColor: Colors.blueGrey[900],
    //     body: Row(
    //       children: [
    //         SocialMedia(
    //           axis: Axis.vertical,
    //           img: imgUrl,
    //         ),
    //         Expanded(
    //           child: Image(
    //             image: NetworkImage(imgUrl),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontFamily: "Rubik",
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _save,
                icon: const Icon(Icons.download),
              ),
            ],
          )
        ],
      ),
      backgroundColor: Colors.pink[300],
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Image(
                    image: NetworkImage(
                      imgUrl,
                    ),
                    width: MediaQuery.of(context).size.height * 0.7,
                    fit: BoxFit.fill,
                  ),
                ),
                // Positioned(
                //   bottom: 60,
                //   left: MediaQuery.of(context).size.width / 10,
                //   right: MediaQuery.of(context).size.width / 10,
                //   child: Text(
                //       '“It is literally true that you can succeed best and quickest by helping others to succeed.”'),
                // ),
                // Positioned(
                //   bottom: 5,
                //   left: MediaQuery.of(context).size.width / 10,
                //   right: MediaQuery.of(context).size.width / 10,
                //   child: SocialMedia(
                //     axis: Axis.horizontal,
                //     img: imgUrl,
                //   ),
                // ),
              ],
            ),
          ),
          SocialMedia(
            networkImage: networkImage,
            img: imgUrl,
          ),
        ],
      ),
    );
  }
}
