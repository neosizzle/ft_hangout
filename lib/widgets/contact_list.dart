import 'package:flutter/material.dart';
import 'package:ft_hangout/pages/message_page.dart';

class ContactList extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final VoidCallback? onEdit;


  const ContactList({
    super.key,
    required this.contacts,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    return contacts.isEmpty
        ? const Center(child: Text('No contacts found.'))
        : ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final int contactId  = contact['id'];
              final String contactName = contact['name'];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    contact['name'][0].toUpperCase(),
                  ),
                ),
                title: Text(contactName),
                subtitle: Text(contact['mobile']),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessagePage(contactId: contactId),
                    ),
                  );

                  onEdit!();
                },
              );
            },
          );
  }
}