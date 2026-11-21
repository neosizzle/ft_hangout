
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
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
                          title: Text(l10n.chooseAppBarColor),
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.55,
                            width: double.maxFinite,
                            child: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: tempColor ?? Colors.white,
                                onColorChanged: (color) {
                                  setDialogState(() {
                                    tempColor = color;
                                  });
                                },
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Text(l10n.cancel),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                appKey.currentState?.changeAppBarColor(
                                  tempColor ?? Colors.white,
                                );

                                Navigator.pop(dialogContext);
                              },
                              child: Text(l10n.apply),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: Text(l10n.changeAppBarColor),
            ),
          ],
        ),
      ),
    );
  }
}
