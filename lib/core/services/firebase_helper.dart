import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insighted/domain/entities/user.dart' as app_entities;

/// Direct Firebase authentication helper that can be used
/// when the dependency injection system is not initialized
class FirebaseHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fallback authentication method using direct Firebase instance
  static Future<Map<String, dynamic>> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      // Try to authenticate with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return {
          'success': false,
          'message': 'Authentication failed - no user found',
        };
      }

      // Get user details from Firestore
      final userDoc =
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (!userDoc.exists) {
        return {
          'success': true,
          'message': 'Authentication successful but user profile not found',
          'user': null,
        };
      }

      // Convert user data
      final userData = userDoc.data()!;
      final user = app_entities.User(
        id: userDoc.id,
        name: userData['name'] ?? 'Unknown',
        email: userData['email'] ?? email,
        phoneNumber: userData['phone_number'],
        role: _mapStringToUserRole(userData['role'] ?? 'admin'),
        schoolId: userData['school_id'],
        schoolName: userData['school_name'],
        isActive: userData['is_active'] ?? true,
        photoUrl: userData['photo_url'],
        createdAt: DateTime.parse(
          userData['created_at'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          userData['updated_at'] ?? DateTime.now().toIso8601String(),
        ),
      );

      return {
        'success': true,
        'message': 'Authentication successful',
        'user': user,
      };
    } catch (e) {
      return {'success': false, 'message': 'Authentication failed: $e'};
    }
  }

  /// Create a user directly with Firebase (fallback method)
  static Future<Map<String, dynamic>> createAdminUser(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Create the user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return {'success': false, 'message': 'Failed to create user'};
      }

      // Create user document in Firestore with more comprehensive data
      final now = DateTime.now();
      final schoolId = 'sch-${_generateShortUuid()}';

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phone_number': '+1 (555) 123-4567',
        'role': 'admin',
        'school_id': schoolId,
        'school_name': 'Westview High School',
        'is_active': true,
        'photo_url':
            'https://ui-avatars.com/api/?name=$name&background=0D8ABC&color=fff',
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });

      // Also create the school document
      await _firestore.collection('schools').doc(schoolId).set({
        'name': 'Westview High School',
        'address': '123 Education Drive, Springfield, IL',
        'phone': '+1 (555) 987-6543',
        'website': 'https://westview.edu',
        'admin_id': userCredential.user!.uid,
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      });

      return {
        'success': true,
        'message': 'Admin user and school created successfully',
        'user_id': userCredential.user!.uid,
        'school_id': schoolId,
      };
    } catch (e) {
      return {'success': false, 'message': 'Failed to create user: $e'};
    }
  }

  /// Create demo users for testing
  /// Note: This method is currently not used as we're focusing only on admin functionality
  static Future<Map<String, dynamic>> createDemoUsers(
    String schoolId,
    String schoolName, {
    bool createOnlyAdmin = true, // Flag to create only admin users
  }) async {
    if (createOnlyAdmin) {
      // TODO: Implementation for creating teacher and parent accounts will be added in future updates
      return {
        'success': true,
        'message': 'Currently only admin accounts are supported',
        'created_users': [],
        'errors': [],
      };
    }

    try {
      final now = DateTime.now();
      final results = <String, dynamic>{
        'success': true,
        'created_users': [],
        'errors': [],
      };

      // Teacher 1
      try {
        final teacher1 = await _auth.createUserWithEmailAndPassword(
          email: 'sjohnson@school.edu',
          password: 'Teacher123',
        );

        await _firestore.collection('users').doc(teacher1.user!.uid).set({
          'name': 'Sarah Johnson',
          'email': 'sjohnson@school.edu',
          'phone_number': '+1 (555) 234-5678',
          'role': 'teacher',
          'school_id': schoolId,
          'school_name': schoolName,
          'is_active': true,
          'photo_url':
              'https://ui-avatars.com/api/?name=Sarah+Johnson&background=2E8B57&color=fff',
          'subject_specialties': ['Mathematics', 'Computer Science'],
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });

        results['created_users'].add('Sarah Johnson (Teacher)');

        // Add a class taught by this teacher
        final classId = 'cls-${_generateShortUuid()}';
        await _firestore.collection('classes').doc(classId).set({
          'name': 'Advanced Mathematics',
          'grade': '11',
          'teacher_id': teacher1.user!.uid,
          'teacher_name': 'Sarah Johnson',
          'academic_year': '2023-2024',
          'term': 'Fall',
          'description':
              'Advanced topics in mathematics including calculus and statistics',
          'schedule': 'MWF 10:00 AM - 11:30 AM',
          'room': 'B201',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });
      } catch (e) {
        results['errors'].add('Failed to create teacher 1: $e');
      }

      // Teacher 2
      try {
        final teacher2 = await _auth.createUserWithEmailAndPassword(
          email: 'mrodriguez@school.edu',
          password: 'Teacher456',
        );

        await _firestore.collection('users').doc(teacher2.user!.uid).set({
          'name': 'Michael Rodriguez',
          'email': 'mrodriguez@school.edu',
          'phone_number': '+1 (555) 345-6789',
          'role': 'teacher',
          'school_id': schoolId,
          'school_name': schoolName,
          'is_active': true,
          'photo_url':
              'https://ui-avatars.com/api/?name=Michael+Rodriguez&background=4682B4&color=fff',
          'subject_specialties': ['Science', 'Biology', 'Chemistry'],
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });

        results['created_users'].add('Michael Rodriguez (Teacher)');

        // Add a class taught by this teacher
        final classId = 'cls-${_generateShortUuid()}';
        await _firestore.collection('classes').doc(classId).set({
          'name': 'Biology 101',
          'grade': '10',
          'teacher_id': teacher2.user!.uid,
          'teacher_name': 'Michael Rodriguez',
          'academic_year': '2023-2024',
          'term': 'Fall',
          'description':
              'Introduction to biological concepts and laboratory techniques',
          'schedule': 'TTh 1:00 PM - 2:30 PM',
          'room': 'A110',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });
      } catch (e) {
        results['errors'].add('Failed to create teacher 2: $e');
      }

      // Parent
      try {
        final parent = await _auth.createUserWithEmailAndPassword(
          email: 'jwilliams@parent.edu',
          password: 'Parent789',
        );

        await _firestore.collection('users').doc(parent.user!.uid).set({
          'name': 'Jessica Williams',
          'email': 'jwilliams@parent.edu',
          'phone_number': '+1 (555) 456-7890',
          'role': 'parent',
          'school_id': schoolId,
          'school_name': schoolName,
          'is_active': true,
          'photo_url':
              'https://ui-avatars.com/api/?name=Jessica+Williams&background=8A2BE2&color=fff',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });

        results['created_users'].add('Jessica Williams (Parent)');

        // Add a student for this parent
        final studentId = 'std-${_generateShortUuid()}';
        await _firestore.collection('students').doc(studentId).set({
          'name': 'David Williams',
          'student_number':
              'S-${_generateShortUuid().substring(0, 6).toUpperCase()}',
          'gender': 'Male',
          'class_id': 'cls-${_generateShortUuid()}',
          'class_name': 'Grade 10-A',
          'photo_url':
              'https://ui-avatars.com/api/?name=David+Williams&background=FF8C00&color=fff',
          'date_of_birth': DateTime(2008, 7, 15).toIso8601String(),
          'parent_id': parent.user!.uid,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });
      } catch (e) {
        results['errors'].add('Failed to create parent: $e');
      }

      return results;
    } catch (e) {
      return {'success': false, 'message': 'Failed to create demo users: $e'};
    }
  }

  /// Simple helper method to check if Firebase is available
  static Future<bool> isFirebaseAvailable() async {
    try {
      await _auth.app.options;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Helper method to map string to UserRole enum
  static app_entities.UserRole _mapStringToUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'teacher':
        return app_entities.UserRole.teacher;
      case 'parent':
        return app_entities.UserRole.parent;
      case 'admin':
      default:
        return app_entities.UserRole.admin;
    }
  }

  // Helper method to generate a short UUID
  static String _generateShortUuid() {
    final fullUuid =
        DateTime.now().millisecondsSinceEpoch.toString() +
        (1000 + (DateTime.now().microsecond % 9000)).toString();
    return fullUuid.substring(fullUuid.length - 8);
  }
}
