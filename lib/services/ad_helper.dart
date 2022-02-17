import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialize;

  AdState(this.initialize);

  static String get bannerhome {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerFuny {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerFav {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerHealth {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerInspir {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerBless {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerQuotePg {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get inline {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstatialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get openAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
