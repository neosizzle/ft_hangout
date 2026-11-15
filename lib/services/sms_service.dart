
import 'package:another_telephony/telephony.dart';
import '../database/database_helper.dart';

class SmsService {
  SmsService._();

  static final SmsService instance = SmsService._();

  final Telephony telephony = Telephony.instance;

  bool _isListening = false;
  Function(Map<String, dynamic>) _onMessageReceived = (_) {};

  set onMessageReceived(Function(Map<String, dynamic>) callback) {
    _onMessageReceived = callback;
  }

  /// Start listening for incoming SMS messages.
  Future<void> startListening() async {
    if (_isListening) return;


    final granted = await telephony.requestSmsPermissions;


    if (granted != true) {
      throw Exception('SMS permission was not granted.');
    }

    _isListening = true;

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {

        final sender = (message.address ?? '').replaceAll(RegExp(r'[^0-9]'), '');
        final body = message.body ?? '';

        if (sender.isEmpty || body.isEmpty) return;

        final contactId = (await DatabaseHelper.instance.getContactByMobile(sender))?['id'];

        // NOTE: ignores unfamiliar contacts
        if (contactId == null) return;

        final newMessage = await DatabaseHelper.instance.insertMessage(
          {
            "contact_id": contactId,
            "contents": body,
            "is_sender": 0,
          }
        );

        _onMessageReceived(newMessage);

        print("=======MSG RECEIVED==========");
        print(sender);
        print(body);
 
        print("=================");

      },
      listenInBackground: false,
    );
  }

  /// Send an actual SMS and save it to the database.
  Future<void> sendSms({
    required String recipient,
    required String message,
    required int contactId,
  }) async {
    if (recipient.trim().isEmpty || message.trim().isEmpty) {
      throw Exception('Recipient and message cannot be empty.');
    }

    final granted = await telephony.requestSmsPermissions;

    if (granted != true) {
      throw Exception('SMS permission was not granted.');
    }

    // Send the real SMS.
    await telephony.sendSms(
      to: recipient,
      message: message,
    );

    print("===========");
    print("======SEND OK=====");
    print("===========");



    // // Only save the message after sending succeeds.
    // await DatabaseHelper.instance.insertSmsMessage(
    //   contactId: contactId,
    //   sender: recipient,
    //   contents: message,
    //   isSender: 1,
    //   createdAt: DateTime.now().toIso8601String(),
    // );
  }
}
