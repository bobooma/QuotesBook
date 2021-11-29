import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  UploadTask? task;
  File? file;

  String enteredVal = "";
  late NetworkImage networkImage;
  String imgUrl = "";
  final controller = TextEditingController();

  void addFile() {
    try {
      FirebaseFirestore.instance.collection("quotes").add({
        "content": enteredVal,
        "imgUrl": imgUrl,
        "time": Timestamp.now()

        // "https://firebasestorage.googleapis.com/v0/b/quotesbook-1ae2f.appspot.com/o/Screenshot_1633357413.png?alt=media&token=bd9615b8-b066-4972-b38c-8c39a1166f56"
      });
      controller.clear();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }

  Future<void> uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = fileName;
    task = FirebaseApi.uploadfile(destination, file!);

    setState(() {});

    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      networkImage = NetworkImage(imgUrl);
      imgUrl = urlDownload;
    });

    print("url:  ..$urlDownload");
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : "no file selected ";

    return Scaffold(
        appBar: AppBar(
          title: const Text('upload images'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: selectFile,
                  child: Row(
                    children: const [
                      Icon(Icons.attach_file),
                      Text('Select file'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      minimumSize: const Size.fromHeight(50)),
                ),
                Text(fileName),
                ElevatedButton(
                  onPressed: uploadFile,
                  child: Row(children: const [
                    Icon(Icons.attach_file),
                    Text('upload file'),
                  ]),
                ),
                task != null
                    ? StreamBuilder<TaskSnapshot>(
                        stream: task!.snapshotEvents,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final snap = snapshot.data!;
                            final progress =
                                snap.bytesTransferred / snap.totalBytes;
                            final percentage =
                                (progress * 100).toStringAsFixed(2);
                            return Text('$percentage %');
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Container(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            labelText: "content upload",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3))),
                        onChanged: (value) {
                          setState(() {
                            enteredVal = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: enteredVal.trim().isEmpty
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              addFile();
                            },
                      icon: const Icon(Icons.send),
                    )
                  ],
                )
              ]),
        ));
  }
}

class FirebaseApi {
  static UploadTask? uploadfile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } catch (e) {
      return null;
    }
  }

  static UploadTask? uploadByte(String destinsation, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destinsation);
      return ref.putData(data);
    } on Exception catch (e) {
      return null;
    }
  }
}
