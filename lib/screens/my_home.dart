import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_quotes/screens/quote.dart';
import 'package:my_quotes/screens/upload_screen.dart';

import '../widgets/my_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  // *** VARIABLES:
  // *

  final quotes = FirebaseFirestore.instance
      .collection("quotes")
      .orderBy("time", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) =>
      // *

      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[600],
          // Theme.of(context).colorScheme.primaryVariant,
          title: const Text('QuotesBook'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: //         // ...quoteData.quotes.map((quote) => InkWell(
              StreamBuilder(
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuoteImage(
                              imgUrl: snapshot.data.docs[index]["imgUrl"]),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Stack(children: [
                        Positioned(
                          child: MyCard(
                              details: snapshot.data.docs[index]["content"]),
                        ),
                        Positioned(
                          top: 20,
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
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const UploadScreen(),
              ));
            }),
      );
}
