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
        icon: const Icon(
          Icons.language,
          // size: media.width * .05,
        ),
        value: locale,
        items: L10n.all.map((locale) {
          final lang = L10n.getLang(locale.languageCode);

          return DropdownMenuItem(
            child: Center(
              child: Text(
                lang,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontSize: media.width * 0.045,
                      // fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            value: locale,
            onTap: () {
              provider.setLocale(locale);
            },
          );
        }).toList(),
        onChanged: (_) {},
        borderRadius: BorderRadius.circular(15),
        style: const TextStyle(fontWeight: FontWeight.bold),
        focusColor: Colors.pink,
        underline: const Divider(),
      ),
    );
  }
}
