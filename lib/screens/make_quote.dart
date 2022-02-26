// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/services.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:my_quotes/providers/utils.dart';
// import 'package:my_quotes/widgets/backgrounds.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';

// import 'package:text_editor/text_editor.dart';

// class MakeQuote extends StatefulWidget {
//   const MakeQuote({Key? key}) : super(key: key);

//   @override
//   _MakeQuoteState createState() => _MakeQuoteState();
// }

// class _MakeQuoteState extends State<MakeQuote> with TickerProviderStateMixin {
//   File? image;

//   Image? img;

//   Uint8List? captureImg;
//   File? file;

//   ScreenshotController screenshotController = ScreenshotController();

//   late TransformationController controller;

//   late AnimationController animationController;

//   Animation<Matrix4>? animation;

//   // resetZoom() {
//   //   animation = Matrix4Tween(begin: controller.value, end: Matrix4.identity())
//   //       .animate(
//   //           CurvedAnimation(parent: animationController, curve: Curves.ease));
//   //   animationController.forward(from: 0);
//   // }

//   screenCapture() async {
//     await Permission.storage.request();
//     final img = await screenshotController.capture();

//     if (img == null) return;

//     setState(() {
//       captureImg = img;
//     });

//     final result = await ImageGallerySaver.saveImage(Uint8List.fromList(img),
//         quality: 60, name: DateTime.now().toString());
//     return result["filePath"];
//   }

//   Future<void> shareScreen() async {
//     //  final path = await screenCapture();
//     // Navigator.of(context).pop();
//     if (captureImg == null) {
//       await screenCapture();
//     }

//     final dir = await getApplicationDocumentsDirectory();
//     final img = File("${dir.path}/flutter.png");

//     img.writeAsBytesSync(captureImg!);
//     Share.shareFiles(
//       [img.path],
//     );
//   }

//   // Future pickImg(ImageSource source) async {
//   //   try {

//   //     final image = await ImagePicker().pickImage(source: source);
//   //     if (image == null) return;

//   //     final imgTemp = File(image.path);

//   //     setState(() {
//   //       this.image = imgTemp;
//   //       img = Image.file(imgTemp);
//   //     });
//   //   } on Exception catch (e) {
//   //     // TODO
//   //   }
//   // }
//   Future pickImg(ImageSource source) async {
//     try {
//       await [
//         Permission.photos,
//         Permission.storage,
//       ].request();
//       final picker = ImagePicker();
//       await picker.pickImage(source: ImageSource.gallery).then((file) async {
//         final ByteData bytes = await rootBundle.load("assets/ic_launcher.png");
//         final Uint8List list = bytes.buffer.asUint8List();
//         final editedImage = await Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ImageEditor(
//               image: Uint8List.fromList(list), // <-- Uint8List of image
//               appBarColor: Colors.blue,
//               bottomBarColor: Colors.blue,
//             ),
//           ),
//         );
//         setState(() {
//           image = editedImage;
//         });
//       });
//     } on Exception catch (e) {
//       // TODO
//     }
//   }

//   final fonts = [
//     'BackOutWeb',
//     'Big Shout Bob',
//     'RubikMonoOne',
//     'RobotoCondensed',
//     'Raleway',
//     'Bubblegum',
//     'Billabong',
//     'Canterbury',
//     'eraser-shade',
//     'BeautifulPeople',
//     'Halimun',
//     'Horizon',
//     'Limelight',
//     'Pokemon Hollow',
//     'SBBTRIAL',
//     'QuiteMagicalRegular',
//     'Sketch 3D',
//     'Stella Demo',
//     'Prumo Slab W00 SemiBold',
//     'Splatch',
//   ];
//   // TextStyle textStyle1 = const TextStyle(
//   //   fontSize: 50,
//   //   color: Colors.white,
//   //   fontFamily: 'Billabong',
//   // );

//   // TextStyle textStyle2 = const TextStyle();
//   // TextStyle textStyle3 = const TextStyle();
//   // String text1 = 'Sample Text';
//   // String text2 = 'Sample Text';
//   // String text3 = 'Sample Text';
//   // // String _text2 = 'Sample Text';
//   // TextAlign _textAlign = TextAlign.center;

//   // bool isVisible = false;
//   // bool isVisible2 = false;

//   void _tapHandler(
//     text,
//     textStyle,
//     textAlign,
//   ) {
//     try {
//       showGeneralDialog(
//         context: context,
//         barrierDismissible: false,
//         transitionDuration: const Duration(
//           milliseconds: 400,
//         ), // how long it takes to popup dialog after button click
//         pageBuilder: (_, __, ___) {
//           // your widget implementation
//           return Container(
//             color: Colors.black.withOpacity(0.4),
//             child: Scaffold(
//               backgroundColor: Colors.transparent,
//               body: SafeArea(
//                 // top: false,
//                 child: TextEditor(
//                   fonts: fonts,
//                   text: text,
//                   textStyle: textStyle,
//                   textAlingment: textAlign,
//                   minFontSize: 10,
//                   onEditCompleted: (style, align, text) {
//                     setState(() {
//                       text1 = text;
//                       textStyle1 = style;
//                       _textAlign = align;
//                     });
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ),
//           );
//         },
//       );
//     } on Exception catch (e) {
//       print(e);
//       // TODO
//     }
//   }

//   // void _tapHandler2(text, textStyle, textAlign) {
//   //   try {
//   //     showGeneralDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       transitionDuration: const Duration(
//   //         milliseconds: 400,
//   //       ), // how long it takes to popup dialog after button click
//   //       pageBuilder: (_, __, ___) {
//   //         // your widget implementation
//   //         return Container(
//   //           color: Colors.black.withOpacity(0.4),
//   //           child: Scaffold(
//   //             backgroundColor: Colors.transparent,
//   //             body: SafeArea(
//   //               // top: false,
//   //               child: TextEditor(
//   //                 fonts: fonts,
//   //                 text: text,
//   //                 textStyle: textStyle,
//   //                 textAlingment: textAlign,
//   //                 minFontSize: 10,
//   //                 onEditCompleted: (style, align, text) {
//   //                   setState(() {
//   //                     text2 = text;
//   //                     textStyle2 = style;
//   //                     _textAlign = align;
//   //                   });
//   //                   Navigator.pop(context);
//   //                 },
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //   } on Exception catch (e) {
//   //     print(e);
//   //     // TODO
//   //   }
//   // }

//   // void _tapHandler3(text, textStyle, textAlign) {
//   //   try {
//   //     showGeneralDialog(
//   //       context: context,
//   //       barrierDismissible: false,
//   //       transitionDuration: const Duration(
//   //         milliseconds: 400,
//   //       ), // how long it takes to popup dialog after button click
//   //       pageBuilder: (_, __, ___) {
//   //         // your widget implementation
//   //         return Container(
//   //           color: Colors.black.withOpacity(0.4),
//   //           child: Scaffold(
//   //             backgroundColor: Colors.transparent,
//   //             body: SafeArea(
//   //               // top: false,
//   //               child: TextEditor(
//   //                 fonts: fonts,
//   //                 text: text,
//   //                 textStyle: textStyle,
//   //                 textAlingment: textAlign,
//   //                 minFontSize: 10,
//   //                 onEditCompleted: (style, align, text) {
//   //                   setState(() {
//   //                     text3 = text;
//   //                     textStyle3 = style;
//   //                     _textAlign = align;
//   //                   });
//   //                   Navigator.pop(context);
//   //                 },
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     );
//   //   } on Exception catch (e) {
//   //     print(e);
//   //     // TODO
//   //   }
//   // }

//   // @override
//   // void initState() {
//   //   super.initState();

//   // controller = TransformationController();
//   // animationController = AnimationController(
//   //     vsync: this, duration: const Duration(milliseconds: 300))
//   //   ..addListener(() {
//   //     controller.value = animation!.value;
//   // //   });
//   // isOne = false;
//   // }

//   // late bool isOne;

//   // @override
//   // void dispose() {
//   //   controller.dispose();
//   //   animationController.dispose();

//   //   super.dispose();
//   // }

//   // toggleVisibility() {
//   //   isVisible = !isVisible;
//   // }

//   AppLocalizations? lang;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         // top: false,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: IconButton(
//                     onPressed: () {
//                       try {
//                         pickImg(ImageSource.gallery);
//                       } on Exception catch (e) {
//                         return;
//                       }
//                     },
//                     icon: const Icon(Icons.image_search),
//                   ),
//                 ),
//                 Expanded(
//                   child: IconButton(
//                     onPressed: () async {
//                       try {
//                         final data = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const Backgrounds(),
//                               ),
//                             ) ??
//                             "assets/ic_launcher.png";

//                         // final File editedFile =
//                         //     await Navigator.of(context).push(
//                         //   MaterialPageRoute(
//                         //     builder: (context) => StoryMaker(
//                         //       filePath: data,
//                         //     ),
//                         //   ),
//                         // );
//                         // setState(() {
//                         //   image = editedFile;
//                         // });

//                         // "https://firebasestorage.googleapis.com/v0/b/quotesbook-1ae2f.appspot.com/o/backgrounds%2Fpexels-alex-andrews-816608.jpg?alt=media&token=48b567af-cbe2-4fcf-8729-3955a3263211";
//                         // setState(() {
//                         //   // img = Image.network(data);
//                         //   image = File(data);
//                         // });
//                       } on Exception catch (e) {
//                         return;
//                       }
//                     },
//                     icon: const Icon(Icons.image),
//                   ),
//                 ),
//                 Expanded(
//                   child: IconButton(
//                     onPressed: () {
//                       try {
//                         pickImg(ImageSource.camera);
//                       } on Exception catch (e) {
//                         return;
//                       }
//                     },
//                     icon: const Icon(Icons.camera),
//                   ),
//                 ),
//                 // Expanded(
//                 //   child: IconButton(
//                 //     onPressed: isVisible
//                 //         ? () {
//                 //             setState(() {
//                 //               isVisible2 = true;
//                 //             });
//                 //           }
//                 //         : () {
//                 //             setState(() {
//                 //               isVisible = true;
//                 //               () {};
//                 //             });
//                 //           },
//                 //     icon: const Icon(Icons.text_format),
//                 //   ),
//                 // ),
//                 Expanded(
//                   child: IconButton(
//                     onPressed: () {
//                       try {
//                         Utils.save(image!.path, context);

//                         // screenCapture();
//                       } on Exception catch (e) {
//                         return;
//                       }
//                     },
//                     icon: const Icon(Icons.download),
//                   ),
//                 ),
//                 Expanded(
//                   child: IconButton(
//                     onPressed: () {
//                       try {
//                         Utils.shareFile(context, image!.path, "");
//                         // shareScreen();
//                       } on Exception catch (e) {
//                         return;
//                       }
//                     },
//                     icon: const Icon(Icons.share),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               // child: Screenshot(
//               //   controller: screenshotController,
//               child: Center(
//                 child: image == null
//                     ? Image.asset("assets/ic_launcher.png")
//                     : Image.file(image!),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
              
              
              
              
              
//                   // child: Stack(
//                   //   overflow: Overflow.visible,
//                   //   fit: StackFit.expand,
//                   //   alignment: Alignment.center,
//                   //   children: [
//                   //     Positioned(
//                   //       child: image == null
//                   //           ? Image.asset("assets/ic_launcher.png")
//                   //           : Image.file(image!),
//                   //     ),
//                       // InteractiveViewer(
//                       //   boundaryMargin: EdgeInsets.all(double.infinity),
//                       //   clipBehavior: Clip.antiAlias,
//                       //   child: GestureDetector(
//                       //     onTap: () => _tapHandler(
//                       //       text1,
//                       //       textStyle1,
//                       //       _textAlign,
//                       //     ),
//                       //     child: Text(
//                       //       text1,
//                       //       style: textStyle1,
//                       //       textAlign: _textAlign,
//                       //     ),
//                       //   ),
//             //           // ),
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // ),

//             // Expanded(
//             //   child: Screenshot(
//             //     controller: screenshotController,
//             //     child: Container(
//             //       // width: double.infinity,
//             //       color: Colors.black,
//             //       child: Center(
//             //         child: Stack(
//             //           overflow: Overflow.visible,
//             //           fit: StackFit.expand,
//             //           alignment: Alignment.center,
//             //           children: [
//             //             Positioned(
//             //               child: img ??
//             //                   Image.asset('assets/splash.png',
//             //                       // width: 50,
//             //                       fit: BoxFit.fill),
//             //             ),
//             //             InteractiveViewer(
//             //               boundaryMargin: EdgeInsets.all(double.infinity),
//             //               clipBehavior: Clip.antiAlias,
//             //               child: GestureDetector(
//             //                 onTap: () => _tapHandler(
//             //                   text1,
//             //                   textStyle1,
//             //                   _textAlign,
//             //                 ),
//             //                 child: Text(
//             //                   text1,
//             //                   style: textStyle1,
//             //                   textAlign: _textAlign,
//             //                 ),
//             //               ),
//             //             ),
//             //             Visibility(
//             //               visible: isVisible,
//             //               child: InteractiveViewer(
//             //                 boundaryMargin: EdgeInsets.all(double.infinity),
//             //                 clipBehavior: Clip.antiAlias,
//             //                 child: GestureDetector(
//             //                   onTap: () => _tapHandler2(
//             //                     text2,
//             //                     textStyle2,
//             //                     _textAlign,
//             //                   ),
//             //                   child: Text(
//             //                     text2,
//             //                     style: textStyle2,
//             //                     textAlign: _textAlign,
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //             Visibility(
//             //               visible: isVisible2,
//             //               child: InteractiveViewer(
//             //                 boundaryMargin: EdgeInsets.all(double.infinity),
//             //                 clipBehavior: Clip.antiAlias,
//             //                 child: GestureDetector(
//             //                   onTap: () => _tapHandler3(
//             //                     text3,
//             //                     textStyle3,
//             //                     _textAlign,
//             //                   ),
//             //                   child: Text(
//             //                     text3,
//             //                     style: textStyle3,
//             //                     textAlign: _textAlign,
//             //                   ),
//             //                 ),
//             //               ),
//             //             ),
//             //           ],
//             //         ),
//             //       ),
//             //     ),
//             //   ),
// //             // ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // typedef void OnPickImageCallback(
// //     double? maxWidth, double? maxHeight, int? quality);

// // class TopTool extends StatelessWidget {
// //   const TopTool({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }
