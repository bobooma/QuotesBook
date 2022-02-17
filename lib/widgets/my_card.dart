import 'package:flutter/material.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:provider/provider.dart';

import '../services/constants.dart';
import '../services/themes.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    Key? key,
    required this.details,
  }) : super(key: key);
  final String details;

  @override
  Widget build(BuildContext context) {
    // Locale locale = Localizations.localeOf(context);

    bool thememode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final media = MediaQuery.of(context).size;
    final content =
        Provider.of<LocaleProvider>(context).langeSwitch(details, context);
    return Provider.of<LocaleProvider>(context).locale.languageCode == "ar" ||
            Provider.of<LocaleProvider>(context).locale.languageCode == "fa" ||
            Provider.of<LocaleProvider>(context).locale.languageCode == "ur"
        ? FutureBuilder(
            future: content,
            builder: (context, AsyncSnapshot<String> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 7,
                  margin: EdgeInsets.only(right: media.width * 0.19),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(right: media.width * 0.19),
                        child: SelectableText(
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
                  margin: EdgeInsets.only(left: media.width * 0.19),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient:
                          // RadialGradient(colors: [
                          //   kPrimaryColor.withRed(255),
                          //   Colors.black54,
                          // ]),
                          !thememode
                              ? LinearGradient(colors: [
                                  kPrimaryColor.withBlue(255),
                                  Colors.white60,
                                ])
                              : LinearGradient(
                                  colors: [
                                    kPrimaryColor.withRed(255),
                                    Colors.black87,
                                  ],
                                ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: media.width * 0.2),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,

                          
                          child: SelectableText(
                            
                            snapshot.data ?? "",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                    fontSize: media.width * 0.035,
                                    fontWeight: FontWeight.bold),
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
