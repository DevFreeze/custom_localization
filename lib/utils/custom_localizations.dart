import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';

class CustomLocalizations {
  CustomLocalizations(this.locale);

  final Locale locale;

  static Map<String, Map<String, String>> _localizedValues = new Map();

  static CustomLocalizations of(BuildContext context) {
    return Localizations.of<CustomLocalizations>(
        context, CustomLocalizations);
  }

  // Load all the Keys and Values of the supported languages from the included JSON files
  // JSON files are located in the path given by const INTL_PATH (normally: "config/intl/")
  Future<void> load() async {
    for (String supportedLanguage in SUPPORTED_LANGUAGES) {
      Map<String, String> _language;

      String data =
          await rootBundle.loadString(INTL_PATH + supportedLanguage + ".json");
      Map<String, dynamic> _result = json.decode(data);

      _language = new Map();
      _result.forEach((String key, dynamic value) {
        _language[key] = value.toString();
      });

      _localizedValues.putIfAbsent(supportedLanguage, () => _language);
    }
  }

  // Get the translation for this specific key
  // If no translation in the given language is available -> fallback language -> If still null -> empty String
  String getTranslation(String key) {
    String _translation = _localizedValues[locale.languageCode][key];

    if (_translation == null) {
      _translation = _localizedValues[FALLBACK_LANGUAGE][key] ?? "";
    }

    return _translation;
  }
}

class CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {

  final Locale overriddenLocale;
  const CustomLocalizationsDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) =>
      SUPPORTED_LANGUAGES.contains(locale.languageCode);

  @override
  Future<CustomLocalizations> load(Locale locale) async {
    CustomLocalizations localizations;

    // If no locale is given -> take the which is set on the phone
    if(overriddenLocale != null) {
      localizations = new CustomLocalizations(overriddenLocale);
    } else {
      localizations = new CustomLocalizations(locale);
    }
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => true;
}
