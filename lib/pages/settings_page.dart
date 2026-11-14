
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    selectedLanguage =
        appKey.currentState?.systemLang ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Change AppBar Color
            ElevatedButton(
              onPressed: () {
                Color? tempColor =
                    appKey.currentState?.appBarColor;

                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          title: const Text('Choose AppBar Color'),
                          content: ColorPicker(
                            pickerColor: tempColor ?? Colors.white,
                            onColorChanged: (color) {
                              setDialogState(() {
                                tempColor = color;
                              });
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appKey.currentState
                                    ?.changeAppBarColor(
                                  tempColor ?? Colors.white,
                                );

                                Navigator.pop(dialogContext);
                              },
                              child: const Text('Apply'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Change AppBar Color'),
            ),

            const SizedBox(height: 24),

            // Language Settings
            const Text(
              'Language',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedLanguage, // TODO: check this
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Language',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'ms',
                  child: Text('Bahasa Melayu'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedLanguage = value;
                });

                appKey.currentState?.changeLang(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
