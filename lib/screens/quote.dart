import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:my_quotes/widgets/social_media.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class QuoteImage extends StatelessWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;

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
              const Text(
                'Save',
                style: TextStyle(
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
            height: 50,
          ),
          Expanded(
            child: Stack(
              children: [
                Image(
                  image: NetworkImage(
                    imgUrl,
                  ),
                  fit: BoxFit.contain,
                ),
                Positioned(
                  bottom: 5,
                  left: MediaQuery.of(context).size.width / 10,
                  right: MediaQuery.of(context).size.width / 10,
                  child: SocialMedia(
                    axis: Axis.horizontal,
                    img: imgUrl,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
