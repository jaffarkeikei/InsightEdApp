import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/core/services/sync_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _version = '';
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Load app version
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = 'v${packageInfo.version}';
        });
      }

      // Initialize database
      _updateStatus('Preparing local database...');
      final dbHelper = ServiceLocator().get<DatabaseHelper>();
      await dbHelper.database; // This will trigger database initialization

      // Check for data to sync
      _updateStatus('Checking data synchronization...');
      final syncService = ServiceLocator().get<SyncService>();

      try {
        // Attempt initial sync if online
        await syncService.synchronizeData();
        _updateStatus('Synchronized with cloud');
      } catch (e) {
        // It's okay if this fails - we're offline-first
        _updateStatus('Operating in offline mode');
      }

      // Finish initialization
      await Future.delayed(const Duration(seconds: 1));
      _updateStatus('Ready');

      // Check authentication status and navigate accordingly
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _updateStatus('Error: $e');
      print('Error initializing app: $e');
      // Give user time to see the error before proceeding anyway
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  void _updateStatus(String message) {
    if (mounted) {
      setState(() {
        _statusMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),
              // Logo
              Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: size.width * 0.2,
                  color: ColorConstants.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              // App name
              Text(
                'InsightEd',
                style: TextStyle(
                  color: ColorConstants.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              Text(
                'Empowering Education Everywhere',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 1),
              // Loading indicator
              SpinKitThreeBounce(
                color: ColorConstants.primaryColor,
                size: 30.0,
              ),
              const SizedBox(height: 16),
              // Status message
              Text(
                _statusMessage,
                style: TextStyle(
                  color: ColorConstants.primaryColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              // Version
              Text(
                _version,
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
