import 'package:flutter/material.dart';
import '../pages/contact_page.dart';

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final int contactId;

  final VoidCallback? onEdit;

  const MessagesAppBar({super.key, required this.username, required this.contactId, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(username),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: 'Edit contact',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactPage(isEdit: true, contactId: contactId,),
              ),
            );

            onEdit!();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}