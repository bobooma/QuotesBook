import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_quotes/widgets/social_media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuoteImage extends StatefulWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    required this.networkImage,
    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;
  final NetworkImage networkImage;

  @override
  State<QuoteImage> createState() => _QuoteImageState();
}

class _QuoteImageState extends State<QuoteImage> {
  File? file;

  _save() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio().get(widget.imgUrl,
          options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: DateTime.now().toString());
    }
  }

  Future<void> shareFile() async {
    await _save();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
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
                      widget.imgUrl,
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
            networkImage: widget.networkImage,
            img: widget.imgUrl,
          ),
        ],
      ),
    );
  }
}
