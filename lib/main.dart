import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:insighted/core/theme/app_theme.dart';
import 'package:insighted/presentation/pages/auth/login_page.dart';
import 'package:insighted/presentation/pages/splash/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Firebase when available
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization failed: $e');
    // App can continue without Firebase in offline mode
  }

  runApp(const InsightEdApp());
}

class InsightEdApp extends StatelessWidget {
  const InsightEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsightEd',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('sw'), // Swahili
      ],
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        // Additional routes will be defined here
      },
    );
  }
}
