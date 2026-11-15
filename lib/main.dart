import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/home_page.dart';
import 'database/database_helper.dart';
import 'l10n/app_localizations.dart';

// TODO: localizations flutter gen-l10n and build
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
  String systemLang = "en";
  Map<String, dynamic>? settings;
  DateTime? lastBackgrounded;


  void changeAppBarColor(Color color) {
    setState(() {
      appBarColor = color;
    });

    String colorStr = '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    DatabaseHelper.instance.updateSettings(headerColor: colorStr, lang: systemLang);
    
  }

  void changeLang(String lang) {
    setState(() {
      systemLang = lang;
    });

    String colorStr = '#${appBarColor.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
    DatabaseHelper.instance.updateSettings(headerColor: colorStr, lang: lang);
  }

  Future<void> loadSettings() async {
    final result = await DatabaseHelper.instance.getSettings();
    
    if (!mounted) return;

    Color loadedColor = const Color(0xFFEF9A86);
    String loadedLang = 'en';

    if (result != null) {
      String colorHex = result['header_color'].replaceAll('#', '');
      loadedColor = Color(int.parse('FF$colorHex', radix: 16));

      String savedLang = result['lang'] ?? 'en';

      if (['en', 'ms'].contains(savedLang)) {
        loadedLang = savedLang;
      }
    }

    setState(() {
      settings = result;
      appBarColor = loadedColor;
      systemLang = loadedLang;
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
      locale: Locale(systemLang),
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
            content: Text('You left the app at $formattedTime'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      lastBackgrounded = null;
    }
  }
}