import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class QuoteModelProvider extends ChangeNotifier {
  late Stream<QuerySnapshot<Map<String, dynamic>>> quoteStream;

  QuoteModelProvider() {
    listenQuote();
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> listenQuote() {
    return quoteStream = FirebaseFirestore.instance
        .collection("quotes")
        .orderBy("time", descending: true)
        .snapshots();
  }
}
