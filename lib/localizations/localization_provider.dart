import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publrealty/localizations/language_helper.dart';
import 'package:publrealty/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  static LocalizationProvider of(BuildContext context) =>
      Provider.of<LocalizationProvider>(context, listen: false);

  LanguageHelper languageHelper = LanguageHelper();

  String currentLanguage = "English";
  Locale _locale = defaultLocale;

  Locale get locale => _locale;

  Future<void> changeLocale(String newLocale) async {
    Locale convertedLocale;

    currentLanguage = newLocale;

    convertedLocale = languageHelper.convertLangNameToLocale(newLocale);
    _locale = convertedLocale;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("appLocale", newLocale);

    notifyListeners();
    return Future.value();
  }

  defineCurrentLanguage(context) {
    return languageHelper
        .convertLocaleToLangName(Localizations.localeOf(context).toString());
  }
}
