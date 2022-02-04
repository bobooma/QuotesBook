import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/widgets/carousal_screen_backgrounds.dart';

class Backgrounds extends StatefulWidget {
//   fun(String img){
// return img;
// }

  @override
  State<Backgrounds> createState() => _BackgroundsState();
}

class _BackgroundsState extends State<Backgrounds> {
  final backgrounds =
      FirebaseFirestore.instance.collection("backgrounds").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: backgrounds,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text('error .....');
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return BackgrounSliders(
              imgs: snapshot,
            );
          },
        ),
      ),
    );
  }
}
