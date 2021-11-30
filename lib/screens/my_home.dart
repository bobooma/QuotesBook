import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_quotes/providers/locale_provider.dart';

import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/screens/upload_screen.dart';
import 'package:my_quotes/widgets/language_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/my_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .orderBy("time", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: media.width * 0.1,
        backgroundColor: Colors.pink[600],
        // Theme.of(context).colorScheme.primaryVariant,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: media.width * .25,
              child: FittedBox(
                child: Text('QuotesBook'),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.newQuote,
                style: TextStyle(
                    fontFamily: "RobotoCondensed",
                    fontSize: media.width * .025,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseLanguage,
                style: TextStyle(
                    fontFamily: "RobotoCondensed",
                    fontSize: media.width * .025),
              ),
              SizedBox(
                width: 5,
              ),
              LangPickWidget(),
            ],
          ),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: quotes,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text('error .....');
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  String content = snapshot.data.docs[index]["content"];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuoteImage(
                              content: content,
                              imgUrl: snapshot.data.docs[index]["imgUrl"]),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: media.width,
                      height: media.height * 0.2,
                      child: Stack(children: [
                        Positioned(child: MyCard(details: content)),
                        Positioned(
                          top: 5,
                          child: Container(
                            height: media.height * 0.2,
                            width: media.height * 0.2,
                            decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(blurRadius: 2)],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    snapshot.data.docs[index]["imgUrl"]),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  );
                });
          },
        ),
      ),
      bottomSheet: Container(
        height: media.height * .1,
        padding:
            Provider.of<LocaleProvider>(context).locale.languageCode == "ar"
                ? EdgeInsets.only(
                    right: 10, left: media.width * .15, top: 5, bottom: 5)
                : EdgeInsets.only(
                    right: media.width * .15, left: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(color: Colors.pink[300]),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                AppLocalizations.of(context)!.fixedQuote,
                maxLines: 2,
                // minFontSize: 10,
                // maxFontSize: 13,
                style: TextStyle(
                    fontSize: media.width * .025,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Raleway"),
              ),
              AutoSizeText(
                AppLocalizations.of(context)!.spread,
                maxLines: 1,
                // minFontSize: media.width * .03,
                // maxFontSize: media.width * .05,
                style: TextStyle(
                  fontSize: media.width * 0.04,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  // fontFamily: "Raleway"
                  fontFamily: "RobotoCondensed",
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.share,
            size: media.width * 0.04,
          ),
          label: Text(
            AppLocalizations.of(context)!.share,
            style: TextStyle(
              fontSize: media.width * 0.035,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              // fontFamily: "Raleway"
              fontFamily: "RobotoCondensed",
            ),
          ),
          onPressed: () {
            // ! admin
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const UploadScreen(),
            ));
            // ! user
            // Share.share("link");
          }),
    );
  }
}
