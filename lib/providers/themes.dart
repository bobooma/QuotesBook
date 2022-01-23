import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

// This is our  main focus
// Let's apply light and dark theme on our app
// Now let's add dark theme on our

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
      cardColor: kPrimaryColor[100],
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kPrimaryColor[300],
      appBarTheme: appBarTheme,
      iconTheme: const IconThemeData(color: kContentColorLightTheme),
      textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: kContentColorLightTheme),
      colorScheme: const ColorScheme.light(
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        error: kErrorColor,
      ),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: kPrimaryColor[300]),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: kPrimaryColor)));
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    cardColor: kPrimaryColor,
    primaryColor: kPrimaryColor[100],
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: kPrimaryColor)),
  );
}

final appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
);