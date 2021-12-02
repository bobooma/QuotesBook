import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:my_quotes/widgets/social_media.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class QuoteImage extends StatefulWidget {
  QuoteImage({
    Key? key,
    required this.imgUrl,
    required this.content,

    // required this.conclusion,
  }) : super(key: key);

  final String imgUrl;
  final String content;

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
    final media = MediaQuery.of(context).size;
    final content =
        Provider.of<LocaleProvider>(context).langeSwitch(widget.content);
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
        body: Provider.of<LocaleProvider>(context).locale.languageCode == "en"
            ? Column(
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
                            width: media.height * 0.7,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SocialMedia(
                    height: media.height * 0.1,
                    img: widget.imgUrl,
                  ),
                ],
              )
            : Column(
                children: [
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
                        FutureBuilder(
                          future: content,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            return Card(
                              elevation: 7,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 3,
                                  right: 3,
                                ),
                                child: Center(
                                  child: Container(
                                    height: media.height * .13,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: SelectableText(
                                        snapshot.data ?? "",
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
                          },
                        )
                      ],
                    ),
                  ),
                  SocialMedia(
                    height: media.height * 0.08,
                    img: widget.imgUrl,
                  ),
                ],
              ));
  }
}
