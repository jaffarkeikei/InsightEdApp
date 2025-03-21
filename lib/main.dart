import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/core/services/sync_service.dart';
import 'package:insighted/core/theme/app_theme.dart';
import 'package:insighted/presentation/pages/splash/splash_page.dart';

bool isServicesInitialized = false;

// Firebase configuration for the InsightEd application
const firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyB7oYD_vNHFxrCOEbsLMpef425afdLQjUA',
  authDomain: 'insighted-education.firebaseapp.com',
  projectId: 'insighted-education',
  storageBucket: 'insighted-education.appspot.com',
  messagingSenderId: '876543210987',
  appId: '1:876543210987:web:1a2b3c4d5e6f7a8b9c0d1e',
  measurementId: 'G-E2C4F6G8H0J',
);

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flag for tracking successful Firebase initialization
  bool firebaseInitialized = false;

  // Step 1: Initialize Firebase when available
  try {
    print('App: Initializing Firebase');
    await Firebase.initializeApp(options: firebaseOptions);
    firebaseInitialized = true;
    print('App: Firebase initialized successfully');
  } catch (e) {
    print('App: Firebase initialization failed: $e');
    // Try initializing without options as fallback
    try {
      await Firebase.initializeApp();
      firebaseInitialized = true;
      print('App: Firebase initialized with default options');
    } catch (e) {
      print('App: Firebase initialization completely failed: $e');
      // App can continue without Firebase in offline mode
    }
  }

  // Step 2: Initialize Hive for local storage
  try {
    print('App: Initializing Hive');
    await Hive.initFlutter();
    print('App: Hive initialized successfully');
  } catch (e) {
    print('App: Hive initialization failed: $e');
    // This is more critical but we can still try to run the app
  }

  // Step 3: Initialize Database but don't wait for completion
  print('App: Creating DatabaseHelper instance');
  final dbHelper = DatabaseHelper();
  print('App: DatabaseHelper instance created');

  // Step 4: Setup dependencies with ServiceLocator
  // If Firebase failed to initialize, we still setup dependencies
  // but some features won't work
  try {
    print('App: Setting up all dependencies');
    await setupDependencies();
    isServicesInitialized = true;
    print('App: All dependencies initialized successfully');

    // Start the sync service monitoring
    print('App: Starting sync service monitoring');
    try {
      final syncService = ServiceLocator().get<SyncService>();
      syncService.startMonitoring();
      print('App: Sync service monitoring started successfully');

      // Perform initial sync
      syncService.synchronizeData().catchError((e) {
        print('App: Initial sync failed: $e');
      });
    } catch (e) {
      print('App: Failed to start sync service: $e');
    }
  } catch (e) {
    print('App: Dependencies setup failed: $e');
    // We'll recover from this in the login page
  }
}

void main() async {
  try {
    await initializeApp();
  } catch (e) {
    print('App: Critical initialization error: $e');
    // App will continue but with limited functionality
  }

  runApp(const InsightEdApp());
}

class InsightEdApp extends StatefulWidget {
  const InsightEdApp({super.key});

  @override
  State<InsightEdApp> createState() => _InsightEdAppState();
}

class _InsightEdAppState extends State<InsightEdApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Clean up database resources when app is closing
    if (isServicesInitialized) {
      print('App: Cleaning up database resources');
      try {
        final dbHelper = ServiceLocator().get<DatabaseHelper>();
        dbHelper
            .close()
            .then((_) {
              print('App: Database closed successfully');
            })
            .catchError((e) {
              print('App: Error closing database: $e');
            });
      } catch (e) {
        print('App: Failed to get database helper: $e');
      }
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // App is being terminated, close database
      if (isServicesInitialized) {
        print('App: App detached, closing database');
        try {
          final dbHelper = ServiceLocator().get<DatabaseHelper>();
          dbHelper.close().catchError((e) {
            print('App: Error closing database: $e');
          });
        } catch (e) {
          print('App: Failed to get database helper: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsightEd - Admin Portal',
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
    );
  }
}
