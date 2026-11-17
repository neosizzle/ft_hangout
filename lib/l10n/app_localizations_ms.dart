// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String helloUser(String name) {
    return 'Helo, $name!';
  }

  @override
  String get newContact => 'Tambah kenalan baharu';

  @override
  String get noContacts => 'Tiada kenalan ditemui';

  @override
  String get addContact => 'Tambah Kenalan';

  @override
  String get editContact => 'Edit Kenalan';

  @override
  String get name => 'Nama';

  @override
  String get mobile => 'Nombor Telefon';

  @override
  String get notes => 'Catatan';

  @override
  String get address => 'Alamat';

  @override
  String get aura => 'Aura';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get update => 'Kemas Kini';

  @override
  String get delete => 'Padam';

  @override
  String get nameRequired => 'Nama diperlukan';

  @override
  String get mobileRequired => 'Nombor telefon diperlukan';

  @override
  String get mobileDigitsOnly =>
      'Nombor telefon mestilah mengandungi digit sahaja';

  @override
  String get auraInvalidInteger => 'Aura mestilah nombor bulat yang sah';

  @override
  String get contactUpdated => 'Kenalan berjaya dikemas kini';

  @override
  String get contactCreated => 'Kenalan berjaya ditambah';

  @override
  String get contactDeleted => 'Kenalan telah dipadam';

  @override
  String failedLoadContact(Object error) {
    return 'Gagal memuatkan kenalan: $error';
  }

  @override
  String failedSaveContact(Object error) {
    return 'Gagal menyimpan kenalan: $error';
  }

  @override
  String get noMessagesYet => 'Belum ada mesej. Mulakan perbualan!';

  @override
  String get typeMessage => 'Taip mesej...';

  @override
  String get settings => 'Tetapan';

  @override
  String get chooseAppBarColor => 'Pilih Warna AppBar';

  @override
  String get apply => 'Gunakan';

  @override
  String get changeAppBarColor => 'Tukar Warna AppBar';

  @override
  String get noContactsFound => 'Tiada kenalan dijumpai.';
}
