import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/home_page.dart';
import 'database/database_helper.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<MyAppState> appKey = GlobalKey<MyAppState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(MyApp(key: appKey));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Color appBarColor = Colors.white;
  Locale? appLocale;
  Map<String, dynamic>? settings;
  DateTime? lastBackgrounded;


  void changeAppBarColor(Color color) {
    setState(() {
      appBarColor = color;
    });

    String colorStr = '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    
    DatabaseHelper.instance.updateSettings(headerColor: colorStr, lang: "en");
    
  }

  void changeLang(String lang) {
    setState(() {
      appLocale = Locale(lang);
    });

    String colorStr = '#${appBarColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    DatabaseHelper.instance.updateSettings(headerColor: colorStr, lang: lang);
  }

  Future<void> loadSettings() async {
    final result = await DatabaseHelper.instance.getSettings();
    
    if (!mounted) return;

    Color loadedColor = const Color(0xFFEF9A86);

    if (result != null) {
      String colorHex = result['header_color'].replaceAll('#', '');
      loadedColor = Color(int.parse('FF$colorHex', radix: 16));
    }

    setState(() {
      settings = result;
      appBarColor = loadedColor;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSettings();
    WidgetsBinding.instance.addObserver(this);
   }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FT Hangout',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          foregroundColor: Colors.white,
        ),
      ),
      locale: appLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('ms'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale != null) {
          for (final locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode) {
              return locale;
            }
          }
        }

        // Default language
        return const Locale('ms');
      },
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: const HomePage(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      lastBackgrounded = DateTime.now();
    }

    if (state == AppLifecycleState.resumed &&
        lastBackgrounded != null) {

      final messenger = scaffoldMessengerKey.currentState;

      if (messenger != null) {
        final formattedTime = MaterialLocalizations.of(
          messenger.context,
        ).formatTimeOfDay(
          TimeOfDay.fromDateTime(lastBackgrounded!),
        );

        messenger.showSnackBar(
          SnackBar(
            content: Text(formattedTime),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      lastBackgrounded = null;
    }
  }
}