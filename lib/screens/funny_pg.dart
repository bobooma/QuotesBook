import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/widgets/page_body.dart';

import '../services/ad_helper.dart';

class FunnyPage extends StatelessWidget {
  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .where("category", isEqualTo: "funny")
      .orderBy("time", descending: true)
      .snapshots();

  FunnyPage({Key? key}) : super(key: key);

  late Size media;

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;

    return PageBody(
      quotes: quotes,
      media: media,
      bannerId: AdState.bannerFuny,
      inlineId: AdState.inline,
    );
  }
}
