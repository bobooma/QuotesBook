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
      iconTheme: IconThemeData(color: kContentColorLightTheme),
      textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: kContentColorLightTheme),
      colorScheme: ColorScheme.light(
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        error: kErrorColor,
      ),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: kPrimaryColor[300]),
      // bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //   backgroundColor: Colors.white,
      //   selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      //   unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      //   selectedIconTheme: IconThemeData(color: kPrimaryColor),
      //   showUnselectedLabels: true,
      // ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: kPrimaryColor)));
}

ThemeData darkThemeData(BuildContext context) {
  // Bydefault flutter provie us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
    // bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0xFF1D1D35)),
    cardColor: kPrimaryColor,
    primaryColor: kPrimaryColor[100],
    // scaffoldBackgroundColor: kPrimaryColor[300],
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: kContentColorDarkTheme),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    // floatingActionButtonTheme: FloatingActionButtonThemeData(
    //     backgroundColor: kContentColorLightTheme.withOpacity(0.7)),

    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   backgroundColor: kContentColorLightTheme,
    //   selectedItemColor: Colors.white70,
    //   unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
    //   selectedIconTheme: IconThemeData(color: kPrimaryColor),
    //   showUnselectedLabels: true,
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: kPrimaryColor)),
  );
}

final appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
);
