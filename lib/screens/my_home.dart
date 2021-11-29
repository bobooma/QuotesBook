import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/screens/upload_screen.dart';
import 'package:my_quotes/widgets/language_picker_widget.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[600],
        // Theme.of(context).colorScheme.primaryVariant,
        title: const Text('QuotesBook'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.chooseLanguage,
                style: TextStyle(fontFamily: "RobotoCondensed", fontSize: 13),
              ),
              SizedBox(
                width: 3,
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
                              networkImage: NetworkImage(
                                  snapshot.data.docs[index]["imgUrl"]),
                              imgUrl: snapshot.data.docs[index]["imgUrl"]),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Stack(children: [
                        Positioned(child: MyCard(details: content)),
                        Positioned(
                          top: 5,
                          child: Container(
                            height: 150,
                            width: 150,
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
      bottomSheet: SingleChildScrollView(
        child: Container(
          height: 90,
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
          decoration: BoxDecoration(color: Colors.pink[300]),
          child: Wrap(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 110),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(AppLocalizations.of(context)!.fixedQuote,
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Raleway")),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: Text(AppLocalizations.of(context)!.spread,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Raleway"
                        fontFamily: "RobotoCondensed",
                        color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: Container(
      //   height: 75,
      //   padding: const EdgeInsets.only(right: 55, left: 10, top: 5, bottom: 5),
      //   decoration: BoxDecoration(color: Colors.pink[300]),
      //   child: Column(
      //     children: [
      //       Text(AppLocalizations.of(context)!.fixedQuote,
      //           style: TextStyle(
      //               fontSize: 11,
      //               fontWeight: FontWeight.bold,
      //               fontFamily: "Raleway")),
      //       SizedBox(
      //         height: 5,
      //       ),
      //       Text('“so..Spread The Good and Share EveryWhere ”',
      //           style: TextStyle(
      //               fontSize: 17,
      //               fontWeight: FontWeight.bold,
      //               // fontFamily: "Raleway"
      //               fontFamily: "RobotoCondensed",
      //               color: Colors.black)),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: ,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(
            Icons.share,
            size: 20,
          ),
          label: Text(
            AppLocalizations.of(context)!.share,
            style: TextStyle(
              fontSize: 8,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              // fontFamily: "Raleway"
              fontFamily: "RobotoCondensed",
            ),
          ),
          onPressed: () {
            // ! admin
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => const UploadScreen(),
            // ));
            // ! user
            Share.share("link");
          }),
    );
  }
}
