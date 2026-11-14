import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/messages_app_bar.dart';

class MessagePage extends StatefulWidget {
  final int contactId;

  const MessagePage({super.key, required this.contactId});

  @override
  MessagePageState createState() => MessagePageState();
}

class MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>>? messages;
  Map<String, dynamic>? contact;

  
  Future<void> loadMessages() async {
    final result = await DatabaseHelper.instance.getAllMessagesFromContactId(widget.contactId);
    if (!mounted) return;

    setState(() {
      messages = result;
    });
  }


  Future<void> loadUser() async {
    final result = await DatabaseHelper.instance.getContactById(widget.contactId);
    if (!mounted) return;

    setState(() {
      contact = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMessages();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MessagesAppBar(username: contact?['name'] ?? '', contactId: widget.contactId, onEdit: loadUser),
      body: Container(),
    );
  }
}