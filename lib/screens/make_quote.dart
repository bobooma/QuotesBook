import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_quotes/widgets/backgrounds.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_editor/text_editor.dart';

class MakeQuote extends StatefulWidget {
  @override
  _MakeQuoteState createState() => _MakeQuoteState();
}

class _MakeQuoteState extends State<MakeQuote> {
  // Image img = Image.asset('assets/story.png');

  File? image;

  Image? img;

  Uint8List? captureImg;
  File? file;

  ScreenshotController screenshotController = ScreenshotController();

  screenCapture() async {
    await Permission.storage.request();
    final img = await screenshotController.capture();

    if (img == null) return;

    setState(() {
      captureImg = img;
    });

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(img),
        quality: 60, name: DateTime.now().toString());
    return result["filePath"];
  }

  Future<void> shareScreen() async {
    //  final path = await screenCapture();
    Navigator.of(context).pop();
    if (captureImg == null) {
      await screenCapture();
    }

    final dir = await getApplicationDocumentsDirectory();
    final img = File("${dir.path}/flutter.png");

    img.writeAsBytesSync(captureImg!);
    Share.shareFiles(
      [img.path],
    );
  }

  Future pickImg(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imgTemp = File(image.path);

      setState(() {
        this.image = imgTemp;
        img = Image.file(imgTemp);
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  final fonts = [
    'Lobster',
    'Rubik',
    'RubikMonoOne',
    'RobotoCondensed',
    'Raleway',
    'JetBrainsMono',
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];
  TextStyle _textStyle = const TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'Billabong',
  );
  String _text = 'Sample Text';
  TextAlign _textAlign = TextAlign.center;

  void _tapHandler(text, textStyle, textAlign) {
    try {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(
          milliseconds: 400,
        ), // how long it takes to popup dialog after button click
        pageBuilder: (_, __, ___) {
          // your widget implementation
          return Container(
            color: Colors.black.withOpacity(0.4),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                // top: false,
                child: Container(
                  child: TextEditor(
                    fonts: fonts,
                    text: text,
                    textStyle: textStyle,
                    textAlingment: textAlign,
                    minFontSize: 10,
                    onEditCompleted: (style, align, text) {
                      setState(() {
                        _text = text;
                        _textStyle = style;
                        _textAlign = align;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  @override
  void initState() {
    super.initState();
    isOne = false;
  }

  late bool isOne;

  Widget buildNewText(BuildContext context) {
    return Positioned(
      child: InteractiveViewer(
        child: GestureDetector(
          onTap: () => _tapHandler(_text, _textStyle, _textAlign),
          child: Text(
            _text,
            style: _textStyle,
            textAlign: _textAlign,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        // top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Backgrounds(),
                            ),
                          ) ??
                          "https://firebasestorage.googleapis.com/v0/b/quotesbook-1ae2f.appspot.com/o/backgrounds%2Fpexels-alex-andrews-816608.jpg?alt=media&token=48b567af-cbe2-4fcf-8729-3955a3263211";
                      setState(() {
                        img = Image.network(data);
                      });
                    },
                    icon: const Icon(
                      Icons.search_off_rounded,
                      // color: Colors.black,
                    ),
                    label: const Text(
                      "Backgrounds",
                      // style: TextStyle(
                      //     color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      pickImg(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () {
                      pickImg(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera),
                  ),
                  IconButton(
                    onPressed: () {
                      screenCapture();
                    },
                    icon: Icon(Icons.download),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  // width: double.infinity,
                  color: Colors.black,
                  child: Stack(
                    // fit: StackFit.expand,
                    // alignment: Alignment.center,
                    children: [
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        child: InteractiveViewer(
                          child: img ??
                              Image.asset(
                                'assets/quote-icon-png-7.jpg',
                                // fit: BoxFit.fill,
                              ),
                        ),
                      ),
                      Positioned(
                        child: InteractiveViewer(
                          child: Center(
                            child: GestureDetector(
                              onTap: () =>
                                  _tapHandler(_text, _textStyle, _textAlign),
                              child: Text(
                                _text,
                                style: _textStyle,
                                textAlign: _textAlign,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
