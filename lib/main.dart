import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/core/services/sync_service.dart';
import 'package:insighted/core/theme/app_theme.dart';
import 'package:insighted/data/repositories/class_repository_impl.dart';
import 'package:insighted/data/repositories/student_repository_impl.dart';
import 'package:insighted/presentation/pages/auth/login_page.dart';
import 'package:insighted/presentation/pages/splash/splash_page.dart';
import 'package:insighted/presentation/providers/class_provider.dart';
import 'package:insighted/presentation/providers/student_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

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

  // Setup dependency injection
  await setupDependencies();

  // Start synchronization service monitoring
  final syncService = ServiceLocator().get<SyncService>();
  syncService.startMonitoring();

  runApp(const InsightEdApp());
}

class InsightEdApp extends StatelessWidget {
  const InsightEdApp({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = ServiceLocator().get<SyncService>();
    final studentRepository = ServiceLocator().get<StudentRepository>();
    final classRepository = ServiceLocator().get<ClassRepository>();

    return MultiProvider(
      providers: [
        // Provide repositories
        Provider<StudentRepository>(create: (_) => studentRepository),
        Provider<ClassRepository>(create: (_) => classRepository),

        // Provide repository providers
        ChangeNotifierProvider<StudentProvider>(
          create: (_) => StudentProvider(repository: studentRepository),
        ),
        ChangeNotifierProvider<ClassProvider>(
          create: (_) => ClassProvider(repository: classRepository),
        ),

        // Stream provider for sync status
        StreamProvider<SyncStatus>(
          create: (_) => syncService.syncStatusStream,
          initialData: SyncStatus(
            isSuccessful: true,
            message: 'Initial state',
            timestamp: DateTime.now(),
          ),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
