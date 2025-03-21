import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:insighted/domain/entities/user.dart' as app_entities;

abstract class AuthRemoteDataSource {
  Future<app_entities.User?> signIn(String email, String password);
  Future<app_entities.User?> getUserByEmail(String email);
  Future<app_entities.User?> getUserById(String id);
  Future<List<app_entities.User>> getUsers();
  Future<List<app_entities.User>> getUsersByRole(app_entities.UserRole role);
  Future<void> createUser(app_entities.User user, String password);
  Future<void> updateUser(app_entities.User user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseFirestore firestore;
  final firebase_auth.FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<app_entities.User?> signIn(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return null;
      }

      // Get the user document from Firestore
      final userDoc =
          await firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (!userDoc.exists) {
        return null;
      }

      return _convertToAppUser(userDoc.data()!, userDoc.id);
    } catch (e) {
      print('AuthRemoteDataSource: Error signing in: $e');
      return null;
    }
  }

  @override
  Future<app_entities.User?> getUserByEmail(String email) async {
    try {
      final querySnapshot =
          await firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      return _convertToAppUser(doc.data(), doc.id);
    } catch (e) {
      print('AuthRemoteDataSource: Error getting user by email: $e');
      return null;
    }
  }

  @override
  Future<app_entities.User?> getUserById(String id) async {
    try {
      final docSnapshot = await firestore.collection('users').doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return _convertToAppUser(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      print('AuthRemoteDataSource: Error getting user by id: $e');
      return null;
    }
  }

  @override
  Future<List<app_entities.User>> getUsers() async {
    try {
      final querySnapshot = await firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => _convertToAppUser(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('AuthRemoteDataSource: Error getting users: $e');
      return [];
    }
  }

  @override
  Future<List<app_entities.User>> getUsersByRole(
    app_entities.UserRole role,
  ) async {
    try {
      final querySnapshot =
          await firestore
              .collection('users')
              .where('role', isEqualTo: role.toString().split('.').last)
              .get();
      return querySnapshot.docs
          .map((doc) => _convertToAppUser(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('AuthRemoteDataSource: Error getting users by role: $e');
      return [];
    }
  }

  @override
  Future<void> createUser(app_entities.User user, String password) async {
    try {
      // Create the Firebase Authentication user
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Use Firebase Auth UID as the Firestore document ID
      final uid = userCredential.user!.uid;

      // Create the Firestore document
      await firestore.collection('users').doc(uid).set({
        'name': user.name,
        'email': user.email,
        'phone_number': user.phoneNumber,
        'role': user.role.toString().split('.').last,
        'school_id': user.schoolId,
        'school_name': user.schoolName,
        'is_active': user.isActive,
        'photo_url': user.photoUrl,
        'created_at': user.createdAt.toIso8601String(),
        'updated_at': user.updatedAt.toIso8601String(),
      });
    } catch (e) {
      print('AuthRemoteDataSource: Error creating user: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUser(app_entities.User user) async {
    try {
      await firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'phone_number': user.phoneNumber,
        'role': user.role.toString().split('.').last,
        'school_id': user.schoolId,
        'school_name': user.schoolName,
        'is_active': user.isActive,
        'photo_url': user.photoUrl,
        'updated_at': user.updatedAt.toIso8601String(),
      });
    } catch (e) {
      print('AuthRemoteDataSource: Error updating user: $e');
      rethrow;
    }
  }

  // Helper method to convert Firestore data to App User entity
  app_entities.User _convertToAppUser(Map<String, dynamic> data, String id) {
    return app_entities.User(
      id: id,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phone_number'],
      role: app_entities.UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == data['role'],
      ),
      schoolId: data['school_id'],
      schoolName: data['school_name'],
      isActive: data['is_active'],
      photoUrl: data['photo_url'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }
}
