import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

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
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
      cardColor: kPrimaryColor100,
      primaryColor: kPrimaryColor.withBlue(255),
      scaffoldBackgroundColor: kPrimaryColor.withBlue(255).withOpacity(0.7),
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
          const BottomSheetThemeData(backgroundColor: kPrimaryColor300),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: kPrimaryColor)));
  return copyWith;
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.black54,
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            primary: kContentColorDarkTheme,
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
    cardColor: kPrimaryColor.withRed(255),
    primaryColor: kPrimaryColor.withRed(255),
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: kPrimaryColor)),
  );
}

AppBarTheme appBarTheme = const AppBarTheme(
  color: kPrimaryColor,
  // .withOpacity(0.3).withAlpha(10),
  centerTitle: false,
  elevation: 0,
);
