import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/providers/themes.dart';

import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/l10n.dart';
import 'screens/my_home.dart';

Future<void> bgHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

bool isLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(bgHandler);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  User? user = FirebaseAuth.instance.currentUser;
  isLogin = user == null ? false : true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LocaleProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => QuoteModelProvider(),
          // ),
        ],
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'QuotesBook',
            locale: provider.locale2,
            themeMode: themeProvider.themeMode,
            theme: lightThemeData(context),
            darkTheme: darkThemeData(context),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home:
                //  FirstScreen(),
                // isLogin?
                const MyHomePage(),
          );
        });
  }
}
