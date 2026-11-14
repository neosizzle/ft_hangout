import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ContactPage extends StatefulWidget {
  final bool isEdit;
  final int? contactId;

  const ContactPage({ super.key, required this.isEdit, this.contactId});

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage> {
  Map<String, dynamic> contact = {
    'id': null,
    'name': '',
    'mobile': '',
    'notes': null,
    'address': null,
    'aura': null,
    'created_at': null,
  };

  Future<void> loadContact(int contactId) async {
    final result = await DatabaseHelper.instance.getContactById(contactId);
    
    if (!mounted) return;
    if (result == null) return;
    
    setState(() {
      contact = result;
    });
  }


  @override
  void initState() {
    super.initState();

    final contactId = widget.contactId;

    if (contactId != null) {
      loadContact(contactId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: make name, mobile, notes, address and aura editable
    // and have a button to cancel which will call navigaor.pop
    // and a save button which will do update or create depends on isedit boolean
    return Scaffold(
      appBar: AppBar(title: const Text('Edit / Add contact')),
      body: const Center(
        child: Text(
          'Edit / add contacts',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
