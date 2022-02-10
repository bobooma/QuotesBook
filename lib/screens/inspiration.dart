import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/widgets/page_body.dart';

import '../services/ad_helper.dart';

class Inspiration extends StatelessWidget {
  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .where("category", isEqualTo: "inspiration")
      .orderBy("time", descending: true)
      .snapshots();

  Inspiration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return PageBody(
      quotes: quotes,
      media: media,
      bannerId: AdState.bannerInspir,
      inlineId: AdState.inline,
    );
  }
}
