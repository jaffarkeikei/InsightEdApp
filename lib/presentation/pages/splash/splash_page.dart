import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/main.dart' show isServicesInitialized, initializeApp;
import 'package:insighted/presentation/pages/auth/login_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String _version = '';
  String _statusMessage = 'Initializing...';
  String _subStatusMessage = '';
  bool _navigationAttempted = false;

  @override
  void initState() {
    super.initState();
    print('SplashPage: initState called');

    // Simple timer as fallback to ensure navigation happens even if initialization fails
    Timer(const Duration(seconds: 10), () {
      if (!_navigationAttempted) {
        print(
          'SplashPage: FALLBACK TIMER triggered - initialization may be hanging',
        );
        _performEmergencyNavigation();
      }
    });

    // Start normal initialization
    _initializeAppSafely();
  }

  void _performEmergencyNavigation() {
    if (mounted && !_navigationAttempted) {
      _navigationAttempted = true;
      print('SplashPage: Performing emergency navigation to login');
      _updateStatus(
        'Proceeding to login...',
        'Some services may not be available',
      );

      // Use direct navigation with minimal dependencies
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _initializeAppSafely() async {
    print('SplashPage: Safe initialization starting');
    try {
      // Load app version
      _updateStatus('Checking app version', '');
      print('SplashPage: Loading package info');
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        print('SplashPage: Package info loaded: ${packageInfo.version}');
        if (mounted) {
          setState(() {
            _version = 'v${packageInfo.version}';
          });
        }
      } catch (e) {
        print('SplashPage: Error loading package info: $e');
        _updateSubStatus('Could not determine app version');
      }

      // Check if services are already initialized
      if (!isServicesInitialized) {
        _updateStatus(
          'Services not fully initialized',
          'Retrying initialization',
        );

        // Try to initialize services again
        try {
          await initializeApp();
          if (isServicesInitialized) {
            _updateStatus('Services initialized successfully', '');
          } else {
            _updateStatus(
              'Some services could not be initialized',
              'Proceeding in offline mode',
            );
          }
        } catch (e) {
          print('SplashPage: Error during initialization retry: $e');
          _updateStatus(
            'Initialization retry failed',
            'Proceeding with limited functionality',
          );
        }
      } else {
        _updateStatus('Services ready', 'All systems initialized');
      }

      // Check if dependencies are registered
      try {
        final serviceLocator = ServiceLocator();
        // Try to access a known dependency to check if setup was done
        try {
          serviceLocator.get<ServiceLocator>();
          _updateStatus('Dependencies verified', 'Services are available');
        } catch (e) {
          _updateStatus(
            'Setting up dependencies',
            'Creating essential services',
          );
          await setupDependencies();
        }
      } catch (e) {
        print('SplashPage: Error checking/setting up dependencies: $e');
        _updateSubStatus('Some services may not be available');
      }

      // Delay slightly to show initialization progress
      await Future.delayed(const Duration(seconds: 1));

      _updateStatus('Ready', 'Proceeding to login');
      await Future.delayed(const Duration(seconds: 1));

      print('SplashPage: Safe initialization complete');

      // Navigate if not already done by emergency timer
      if (mounted && !_navigationAttempted) {
        _navigationAttempted = true;
        print('SplashPage: Navigating to login page after safe initialization');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      print('SplashPage: ERROR during safe initialization: $e');
      _updateStatus('Error during initialization', e.toString());

      // Wait briefly then perform emergency navigation
      await Future.delayed(const Duration(seconds: 2));
      _performEmergencyNavigation();
    }
  }

  void _updateStatus(String message, String subMessage) {
    print('SplashPage: Status update: $message | $subMessage');
    if (mounted) {
      setState(() {
        _statusMessage = message;
        _subStatusMessage = subMessage;
      });
    }
  }

  void _updateSubStatus(String subMessage) {
    print('SplashPage: Sub-status update: $subMessage');
    if (mounted) {
      setState(() {
        _subStatusMessage = subMessage;
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_subStatusMessage.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _subStatusMessage,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
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
