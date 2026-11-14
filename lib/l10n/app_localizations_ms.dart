// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Aplikasi Saya';

  @override
  String get welcome => 'Selamat Datang';

  @override
  String helloUser(String name) {
    return 'Hai, $name!';
  }

  @override
  String get newContact => 'Tambah kontak baru';
}
