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
        alignment: Alignment.centerRight,
        icon: const Icon(
          Icons.language,
          // size: media.width * .05,
        ),
        value: locale,
        items: L10n.all.map((locale) {
          final lang = L10n.getLang(locale.languageCode);

          return DropdownMenuItem(
            child: Text(
              lang,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  // fontSize: media.width * 0.045,
                  // fontWeight: FontWeight.bold,
                  ),
            ),
            value: locale,
            onTap: () {
              try {
                provider.setLocale(locale);
              } on Exception catch (e) {
                // TODO
              }
            },
          );
        }).toList(),
        onChanged: (_) {},
        style: const TextStyle(fontWeight: FontWeight.bold),
        focusColor: Colors.pink,
        underline: const Divider(),
      ),
    );
  }
}
