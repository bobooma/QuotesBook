import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/l10n/l10n.dart';
import 'package:translator/translator.dart';

class LocaleProvider extends ChangeNotifier {
  final translator = GoogleTranslator();

  Locale _locale = L10n.all[0];

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  Future<String> langeSwitch(String content) async {
    switch (_locale.languageCode) {
      case "en":
        return content = content;

      case "ar":
        var trans = await translator.translate(content, from: "en", to: "ar");
        return content = trans.text;

      case "es":
        var trans = await translator.translate(content, from: "en", to: "es");
        return content = trans.text;

      case "hi":
        var trans = await translator.translate(content, from: "en", to: "hi");
        return content = trans.text;

      case "ja":
        var trans = await translator.translate(content, from: "en", to: "ja");
        return content = trans.text;
      case "de":
        var trans = await translator.translate(content, from: "en", to: "de");
        return content = trans.text;
      case "it":
        var trans = await translator.translate(content, from: "en", to: "it");
        return content = trans.text;
      case "id":
        var trans = await translator.translate(content, from: "en", to: "id");
        return content = trans.text;
      case "ko":
        var trans = await translator.translate(content, from: "en", to: "ko");
        return content = trans.text;

      case "tl":
        var trans = await translator.translate(content, from: "en", to: "tl");
        return content = trans.text;
      case "fr":
        var trans = await translator.translate(content, from: "en", to: "fr");
        return content = trans.text;
      case "ru":
        var trans = await translator.translate(content, from: "en", to: "ru");
        return content = trans.text;
      case "bn":
        var trans = await translator.translate(content, from: "en", to: "bn");
        return content = trans.text;
      case "fa":
        var trans = await translator.translate(content, from: "en", to: "fa");
        return content = trans.text;

      case "pt":
        var trans = await translator.translate(content, from: "en", to: "pt");
        return content = trans.text;
      case "tr":
        var trans = await translator.translate(content, from: "en", to: "tr");
        return content = trans.text;
      case "ur":
        var trans = await translator.translate(content, from: "en", to: "ur");
        return content = trans.text;
      case "vi":
        var trans = await translator.translate(content, from: "en", to: "vi");
        return content = trans.text;
      case "ms":
        var trans = await translator.translate(content, from: "en", to: "ms");
        return content = trans.text;

      case "zh":
        var trans =
            await translator.translate(content, from: "en", to: "zh-cn");
        return content = trans.text;
      default:
        return content = content;
      // setState(() {
      // });

    }
  }

  void clearLocale() {
    _locale = L10n.all[0];
  }
}
