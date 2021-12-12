import 'package:flutter/material.dart';
import 'package:my_quotes/l10n/l10n.dart';
import 'package:my_quotes/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LangPickWidget extends StatelessWidget {
  const LangPickWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = provider.locale;
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        icon: Icon(
          Icons.arrow_right,
          color: Colors.black,
          size: media.width * .07,
        ),
        value: locale,
        items: L10n.all.map((locale) {
          return DropdownMenuItem(
            child: Center(
              child: Text(
                locale.languageCode,
                style: TextStyle(
                    color: Colors.black, fontSize: media.width * 0.03),
              ),
            ),
            value: locale,
            onTap: () {
              provider.setLocale(locale);
            },
          );
        }).toList(),
        onChanged: (_) {},
      ),
    );
  }
}
