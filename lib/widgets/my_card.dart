import 'package:flutter/material.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.details,
  }) : super(key: key);
  final String details;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final content = Provider.of<LocaleProvider>(context).langeSwitch(details);
    return Provider.of<LocaleProvider>(context).locale.languageCode == "ar"
        ? FutureBuilder(
            future: content,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 7,
                  margin: EdgeInsets.only(right: media.width * 0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(right: 70),
                        child: Text(
                          snapshot.data ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //
                            // ***
                            // TODO rEVISION
                            //overflow: TextOverflow.ellipsis,
                            fontSize: media.width * 0.035,
                            // letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            fontFamily: "RobotoCondensed",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : FutureBuilder(
            future: content,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 7,
                  margin: EdgeInsets.only(left: media.width * 0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(left: 70),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            snapshot.data ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              //
                              // ***
                              // TODO rEVISION
                              //overflow: TextOverflow.ellipsis,
                              fontSize: media.width * .035,
                              fontWeight: FontWeight.bold,
                              // letterSpacing: 2,
                              fontFamily: "RobotoCondensed",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
