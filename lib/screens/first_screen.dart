import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:my_quotes/widgets/first_language_picker_widget.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatelessWidget {
  UserCredential? userCredential;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: FirstLangPickWidget()),
    );
  }
}
