// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale("en"),
    const Locale("es"),
    const Locale("ar"),
    const Locale("hi"),
    const Locale("ja"),
    const Locale("tl"),
    const Locale("zh"),
    const Locale("ru"),
    const Locale("fr"),
    const Locale("id"),
    const Locale("ko"),
    const Locale("it"),
    const Locale("de"),
    const Locale("bn"),
    const Locale("pt"),
    const Locale("vi"),
    const Locale("ur"),
    const Locale("tr"),
    const Locale("fa"),
    const Locale("pa"),
    const Locale("gu"),
    const Locale("mr"),
    const Locale("ms"),
    const Locale("ta"),
    const Locale("te"),
    const Locale("th"),
    const Locale("sw"),
  ];

  static String getLang(String code) {
    switch (code) {
      case "ar":
        return "العربية ";

      case "es":
        return "Española";

      case "hi":
        return "भारतीय";

      case "ja":
        return "日本";
      case "de":
        return "Deutsch";
      case "it":
        return "Italiana";
      case "id":
        return "bahasa Indonesia";
      case "ko":
        return "한국인";

      case "tl":
        return "Tagalog";
      case "fr":
        return "Français";
      case "ru":
        return "русский";
      case "bn":
        return "বাংলা";
      case "fa":
        return "فارسی";

      case "pt":
        return "português";
      case "tr":
        return "Türk";
      case "ur":
        return "اردو";
      case "vi":
        return "Tiếng Việt";
      case "pa":
        return "ਮਾਲੇਈ ਭਾਸ਼ਾ";
      case "gu":
        return "અંગ્રેજી";
      case "mr":
        return "इंग्रजी";
      case "ms":
        return "Bahasa Inggeris";
      case "sw":
        return "Kiingereza";
      case "ta":
        return "ஆங்கிலம்";
      case "te":
        return "ఆంగ్ల";
      case "th":
        return "ภาษาอังกฤษ";

      case "zh":
        return "中国人";
      case "en":
      default:
        return "English";
    }
  }
}
