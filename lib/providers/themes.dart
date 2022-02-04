import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

ThemeData lightThemeData(BuildContext context) {
  var copyWith = ThemeData.light().copyWith(
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: kContentColorLightTheme,
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
      cardColor: kPrimaryColor[100],
      primaryColor: Color.fromARGB(225, 85, 37, 168),
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
  return copyWith;
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            primary: kContentColorDarkTheme,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
    cardColor: kPrimaryColor,
    primaryColor: kPrimaryColor[100],
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Color.fromARGB(225, 85, 37, 168),
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: kPrimaryColor)),
  );
}

const appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
);
