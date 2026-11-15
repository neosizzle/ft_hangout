import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ft_hangout/main.dart';
import '../database/database_helper.dart';
import 'contact_page.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/contact_list.dart';
import '../l10n/app_localizations.dart';
import '../services/sms_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
 List<Map<String, dynamic>>? contacts;

  Future<void> loadContacts() async {
    final result = await DatabaseHelper.instance.getAllContacts();
 
    if (!mounted) return;

    setState(() {
      contacts = result;
    });
  }

  @override
  void initState() {
    super.initState();
    loadContacts();
    SmsService.instance.startListening();

  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const HomeAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
             ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactPage(isEdit: false),
                  ),
                );

                loadContacts();
              },
              child: Text(l10n.newContact),
            ),

            const SizedBox(height: 20),
            
            Expanded(
              child: contacts == null
                  ? const Center(child: CircularProgressIndicator())
                  : contacts!.isEmpty
                      ? const Center(child: Text('No contacts found.'))
                      : ContactList(contacts: contacts ?? [], onEdit: loadContacts,),
            ),

          ],
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {

//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome to Home Page',
//               style: TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ContactsPage(),
//                   ),
//                 );
//               },
//               child: const Text('Go to Contacts'),
//             ),

//              ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const MessagePage(),
//                   ),
//                 );
//               },
//               child: const Text('Go to Message'),
//             ),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const SettingsPage(),
//                   ),
//                 );
//               },
//               child: const Text('Go to Settings'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }