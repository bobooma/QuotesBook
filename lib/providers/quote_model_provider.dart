import 'package:flutter/cupertino.dart';

class QuoteModelProvider extends ChangeNotifier {
  bool isFav = false;

  isFavTrue() {
    isFav = true;

    notifyListeners();
  }

  isFavFalse() {
    isFav = false;

    notifyListeners();
  }
}
