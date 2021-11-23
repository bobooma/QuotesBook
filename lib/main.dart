import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import 'l10n/l10n.dart';
import 'screens/my_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuotesBook',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: const TextTheme(
                headline6: TextStyle(
                  fontSize: 35,
                  letterSpacing: 2,
                ),
                bodyText2: TextStyle(),
                button: TextStyle(letterSpacing: 3))
            .apply(
          fontFamily: "Lobster",
        ),
        scaffoldBackgroundColor: Colors.pink[300],
        cardColor: Colors.pink[100],
      ),
      supportedLocales: L10n.all,
      home: MyHomePage(),
    );
  }
}
