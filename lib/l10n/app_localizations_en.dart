// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String helloUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String get newContact => 'Add new contact';

  @override
  String get noContacts => 'No contacts found';

  @override
  String get addContact => 'Add Contact';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get name => 'Name';

  @override
  String get mobile => 'Mobile';

  @override
  String get notes => 'Notes';

  @override
  String get address => 'Address';

  @override
  String get aura => 'Aura';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get mobileRequired => 'Mobile is required';

  @override
  String get mobileDigitsOnly => 'Mobile must contain digits only';

  @override
  String get auraInvalidInteger => 'Aura must be a valid integer';

  @override
  String get contactUpdated => 'Contact updated successfully';

  @override
  String get contactCreated => 'Contact created successfully';

  @override
  String get contactDeleted => 'Contact deleted';

  @override
  String failedLoadContact(Object error) {
    return 'Failed to load contact: $error';
  }

  @override
  String failedSaveContact(Object error) {
    return 'Failed to save contact: $error';
  }

  @override
  String get noMessagesYet => 'No messages yet. Say hello!';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get settings => 'Settings';

  @override
  String get chooseAppBarColor => 'Choose AppBar Color';

  @override
  String get apply => 'Apply';

  @override
  String get changeAppBarColor => 'Change AppBar Color';

  @override
  String get noContactsFound => 'No contacts found.';
}
