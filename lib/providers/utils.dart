import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  
   static save(String imgUrl , BuildContext context) async {
    Navigator.of(context).pop();
    var status = await Permission.storage.request();
    if (status.isGranted) {
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name:
              "screenshot ${DateTime.now().toIso8601String().replaceAll(".", "_").replaceAll(":", "_")}");
    }
  }

  static Future<void> shareFile(BuildContext context, String img, String content) async {
    Navigator.of(context).pop();
    final url = Uri.parse(img);
    final response = await get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/img.jpg";
    File(path).writeAsBytesSync(bytes);
    // ! revision
    Share.shareFiles([path], subject: content, text: content);
    print(content);

    // await _save();
    // final result = await FilePicker.platform.pickFiles(
    //   allowMultiple: false,
    // );
    // if (result == null) return;
    // final path = result.files.single.path!;
    // setState(() => file = File(path));
  }



 


}