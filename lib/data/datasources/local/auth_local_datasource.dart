import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:insighted/core/database/database_helper.dart';
import 'package:insighted/domain/entities/user.dart';
import 'package:uuid/uuid.dart';

abstract class AuthLocalDataSource {
  Future<User?> getUserByEmail(String email);
  Future<User?> getUserById(String id);
  Future<void> saveUser(User user, String password);
  Future<void> updateUser(User user);
  Future<bool> verifyPassword(String email, String password);
  Future<List<User>> getUsers();
  Future<List<User>> getUsersByRole(UserRole role);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final DatabaseHelper dbHelper;

  AuthLocalDataSourceImpl({required this.dbHelper});

  // Hash password using SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _convertToUser(maps.first);
  }

  @override
  Future<User?> getUserById(String id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return _convertToUser(maps.first);
  }

  @override
  Future<void> saveUser(User user, String password) async {
    final userMap = _toMap(user);
    userMap['password_hash'] = _hashPassword(password);
    userMap['is_synced'] = 0; // Mark as needing sync
    await dbHelper.insert('users', userMap);
  }

  @override
  Future<void> updateUser(User user) async {
    final userMap = _toMap(user);
    userMap['is_synced'] = 0; // Mark as needing sync
    await dbHelper.update('users', userMap, 'id', user.id);
  }

  @override
  Future<bool> verifyPassword(String email, String password) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      columns: ['password_hash'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      return false;
    }

    final storedHash = maps.first['password_hash'] as String;
    final inputHash = _hashPassword(password);
    return storedHash == inputHash;
  }

  @override
  Future<List<User>> getUsers() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return maps.map((map) => _convertToUser(map)).toList();
  }

  @override
  Future<List<User>> getUsersByRole(UserRole role) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: [role.toString().split('.').last],
    );
    return maps.map((map) => _convertToUser(map)).toList();
  }

  // Helper methods to convert between User entity and database maps
  User _convertToUser(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == map['role'],
      ),
      schoolId: map['school_id'],
      schoolName: map['school_name'],
      isActive: map['is_active'] == 1,
      photoUrl: map['photo_url'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> _toMap(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone_number': user.phoneNumber,
      'role': user.role.toString().split('.').last,
      'school_id': user.schoolId,
      'school_name': user.schoolName,
      'is_active': user.isActive ? 1 : 0,
      'photo_url': user.photoUrl,
      'created_at': user.createdAt.toIso8601String(),
      'updated_at': user.updatedAt.toIso8601String(),
    };
  }
}
