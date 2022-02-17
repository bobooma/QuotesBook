import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/services/ad_helper.dart';

import 'package:my_quotes/widgets/page_body.dart';

class Blessings extends StatelessWidget {
  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .where("category", isEqualTo: "bless")
      .orderBy("time", descending: true)
      .snapshots();

  Blessings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return PageBody(
      quotes: quotes,
      media: media,
      bannerId: AdState.bannerBless,
      inlineId: AdState.inline,
    );
  }
}
