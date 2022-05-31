// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/preferences.dart';
import 'package:delivery/src/core/utils/language_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

LanguageMode locale2Language(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return LanguageMode.en;
    case 'sk':
      return LanguageMode.sk;
    default:
      return LanguageMode.en;
  }
}

Locale language2locale(LanguageMode mode) {
  return AppLocalizations.supportedLocales.firstWhere(
    (element) => mode.toString().contains(element.languageCode),
    orElse: () => AppLocalizations.supportedLocales.first,
  );
}

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  SharedPreferencesService(this.sharedPreferences);

  Future<void> clearPreferences() async {
    await sharedPreferences.clear();
  }

  Future<void> setAppLocale(LanguageMode locale) async {
    await sharedPreferences.setInt(
        AppPreferencesKeys.preferencesLanguage, locale.index);
  }

  LanguageMode getAppLanguage() {
    final languageId =
        sharedPreferences.getInt(AppPreferencesKeys.preferencesLanguage);

    if (languageId != null &&
        languageId >= 0 &&
        languageId < LanguageMode.values.length) {
      return LanguageMode.values.elementAt(languageId);
    } else {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

      return locale2Language(systemLocale);
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await sharedPreferences.setInt(
        AppPreferencesKeys.preferencesThemeMode, themeMode.index);
  }

  ThemeMode getThemeMode() {
    if (kIsWeb) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.values.elementAt(
          sharedPreferences.getInt(AppPreferencesKeys.preferencesThemeMode) ??
              0);
    }
  }

  Future<void> setLayoutMode(SupportedLayoutMode layoutMode) async {
    await sharedPreferences.setInt(
        AppPreferencesKeys.preferencesLayoutMode, layoutMode.index);
  }

  SupportedLayoutMode getLayoutMode() => SupportedLayoutMode.values.elementAt(
      sharedPreferences.getInt(AppPreferencesKeys.preferencesLayoutMode) ?? 0);

  Future<void> setTermsAgreed({required bool termsAgreed}) async {
    await sharedPreferences.setBool(
        AppPreferencesKeys.preferencesTermsAgreed, termsAgreed);
  }

  bool getTermsAgreed() =>
      sharedPreferences.getBool(AppPreferencesKeys.preferencesTermsAgreed) ??
      false;

  bool getHasAgeVerified() {
    return sharedPreferences.getBool(AppPreferencesKeys.hasAgeVerified) ??
        false;
  }

  Future<void> setHasAgeVerified({required bool verified}) {
    return sharedPreferences.setBool(
        AppPreferencesKeys.hasAgeVerified, verified);
  }
}

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());
