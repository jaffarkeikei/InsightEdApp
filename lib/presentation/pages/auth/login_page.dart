import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/services/firebase_helper.dart';
import 'package:insighted/core/services/service_locator.dart';
import 'package:insighted/domain/entities/user.dart';
import 'package:insighted/presentation/providers/auth_provider.dart';
import 'package:insighted/presentation/pages/dashboard/admin_dashboard_page.dart';
import 'package:insighted/presentation/pages/dashboard/parent_dashboard_page.dart';
import 'package:insighted/presentation/pages/dashboard/teacher_dashboard_page.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInitialized = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Initialize services and admin account if needed
  Future<void> _initializeServices() async {
    if (_isInitialized) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Ensure dependencies are set up
      await setupDependencies();

      // Now check for admin user
      await _checkAndCreateAdminUser();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('LoginPage: Error initializing services: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Initialization error: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Initialize admin account and demo data if needed
  Future<void> _checkAndCreateAdminUser() async {
    try {
      // First make sure we can access the ServiceLocator
      final serviceLocator = ServiceLocator();

      // Check if AuthProvider is registered
      if (!serviceLocator.isRegistered<AuthProvider>()) {
        print(
          'LoginPage: AuthProvider not registered, attempting to set up dependencies',
        );
        try {
          await setupDependencies();
        } catch (e) {
          print('LoginPage: Error setting up dependencies: $e');
          setState(() {
            _errorMessage = 'Failed to initialize services: $e';
          });
          return;
        }
      }

      final authProvider = serviceLocator.get<AuthProvider>();

      // Check if admin exists (try in both authentication systems)
      User? adminUser = await authProvider.getUserByEmail('admin@school.edu');

      if (adminUser == null) {
        print(
          'LoginPage: Admin user does not exist, creating admin account...',
        );

        try {
          // First try with the service locator
          final now = DateTime.now();

          // Create the admin user with more comprehensive data
          final schoolId =
              'sch-${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}';
          final adminUser = User(
            id: const Uuid().v4(),
            name: 'Administrator',
            email: 'admin@school.edu',
            phoneNumber: '+1 (555) 123-4567',
            role: UserRole.admin,
            schoolId: schoolId,
            schoolName: 'Westview High School',
            isActive: true,
            photoUrl:
                'https://ui-avatars.com/api/?name=Administrator&background=0D8ABC&color=fff',
            createdAt: now,
            updatedAt: now,
          );

          await authProvider.createUser(adminUser, '10Admin10');
          print('LoginPage: Admin user created successfully via AuthProvider');

          // TODO: Add teacher and parent account creation in future updates
        } catch (e) {
          print('LoginPage: Error creating users with AuthProvider: $e');

          // Fall back to direct Firebase access if primary method fails
          if (await FirebaseHelper.isFirebaseAvailable()) {
            print('LoginPage: Attempting fallback Firebase admin creation');
            final adminResult = await FirebaseHelper.createAdminUser(
              'admin@school.edu',
              '10Admin10',
              'Administrator',
            );

            if (adminResult['success']) {
              print(
                'LoginPage: Admin user created successfully via FirebaseHelper',
              );
              // TODO: Add teacher and parent account creation in future updates
            } else {
              print(
                'LoginPage: Firebase admin creation failed: ${adminResult['message']}',
              );
              setState(() {
                _errorMessage =
                    'Failed to create admin user: ${adminResult['message']}';
              });
            }
          } else {
            print('LoginPage: Firebase is not available for fallback');
            setState(() {
              _errorMessage =
                  'Failed to create admin user and Firebase is not available';
            });
          }
        }
      } else {
        print('LoginPage: Admin user already exists');
      }
    } catch (e) {
      print('LoginPage: Error checking/creating admin user: $e');
      setState(() {
        _errorMessage = 'Error initializing admin user: $e';
      });
    }
  }

  // Helper methods to create demo data will be implemented in future updates
  /* 
  // The following methods will be implemented in future updates:
  - _createDemoTeachers()
  - _createDemoParents()
  - _createDemoStudents()
  - _createDemoClasses()
  */

  @override
  void initState() {
    super.initState();
    // Initialize services after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeServices();
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ensure services are initialized before proceeding
    if (!_isInitialized) {
      await _initializeServices();
      // If still not initialized, we'll try fallback authentication
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = false;
      User? user;

      // Try primary authentication using the AuthProvider
      if (_isInitialized) {
        try {
          final authProvider = ServiceLocator().get<AuthProvider>();
          success = await authProvider.signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
          if (success) {
            user = authProvider.currentUser;
          } else {
            _errorMessage = authProvider.error ?? 'Login failed';
          }
        } catch (e) {
          print('LoginPage: Primary authentication failed: $e');
          // Will fall back to direct Firebase authentication
        }
      }

      // If primary authentication failed or not available, try direct Firebase authentication
      if (!success && await FirebaseHelper.isFirebaseAvailable()) {
        print('LoginPage: Attempting fallback Firebase authentication');
        final result = await FirebaseHelper.authenticateUser(
          _emailController.text.trim(),
          _passwordController.text,
        );

        success = result['success'] as bool;
        if (success && result['user'] != null) {
          user = result['user'] as User;
        } else {
          _errorMessage = result['message'] as String;
        }
      }

      if (mounted && success && user != null) {
        // Check if user is admin - for now only allow admin login
        if (user.role != UserRole.admin) {
          setState(() {
            _errorMessage = 'Currently only admin login is supported';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Currently only admin login is supported'),
              backgroundColor: ColorConstants.errorColor,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Show success message and navigate to appropriate dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful as Administrator'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );

        // For now, only navigate to the admin dashboard
        // TODO: Add navigation for teacher and parent roles in future updates
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboardPage(),
              ),
            );
          }
        });
      } else if (mounted) {
        // Show error message
        setState(() {
          if (_errorMessage == null) {
            _errorMessage = 'Authentication failed';
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: ColorConstants.errorColor,
          ),
        );
      }
    } catch (e) {
      print('LoginPage: Login error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Login failed: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: ColorConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo and App Name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        decoration: BoxDecoration(
                          color: ColorConstants.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          size: size.width * 0.15,
                          color: ColorConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'InsightEd',
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Admin Portal',
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Log in to continue',
                        style: TextStyle(
                          color: ColorConstants.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error message display
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorConstants.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: ColorConstants.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                // Login Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      Text(
                        'Email',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: ColorConstants.primaryColor,
                          ),
                          fillColor: ColorConstants.inputFillColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      Text(
                        'Password',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: ColorConstants.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: ColorConstants.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          fillColor: ColorConstants.inputFillColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Log in',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Demo Credentials Hint
                      Center(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorConstants.primaryColor.withOpacity(
                                0.3,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Admin Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Admin Account
                              _buildCredentialCard(
                                role: 'Admin',
                                name: 'Administrator',
                                email: 'admin@school.edu',
                                password: '10Admin10',
                                color: Colors.indigo,
                                icon: Icons.admin_panel_settings,
                              ),

                              // Remove teacher and parent cards
                              const SizedBox(height: 8),
                              Text(
                                'Teacher and parent accounts will be added in future updates',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorConstants.secondaryTextColor,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialCard({
    required String role,
    required String name,
    required String email,
    required String password,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            role,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Name: $name',
            style: TextStyle(color: ColorConstants.secondaryTextColor),
          ),
          Text(
            'Email: $email',
            style: TextStyle(color: ColorConstants.secondaryTextColor),
          ),
          Text(
            'Password: $password',
            style: TextStyle(color: ColorConstants.secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
