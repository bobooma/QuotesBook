import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/widgets/page_body.dart';

import '../services/ad_helper.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  String? userId;

  late User user;

  getUser() {
    user = FirebaseAuth.instance.currentUser!;
    userId = user.uid;
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> quotes;
  late Size media;

  @override
  Widget build(BuildContext context) {
    quotes = FirebaseFirestore.instance
        .collection("favorite")
        .where("userId", isEqualTo: userId)
        .orderBy("time", descending: true)
        .snapshots();
    media = MediaQuery.of(context).size;

    return PageBody(
      quotes: quotes,
      media: media,
      bannerId: AdState.bannerFav,
      inlineId: AdState.inline,
    );
  }
}
