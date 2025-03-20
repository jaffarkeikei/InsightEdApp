import 'package:equatable/equatable.dart';

enum UserRole { admin, teacher, parent }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserRole role;
  final String? schoolId;
  final String? schoolName;
  final bool isActive;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.schoolId,
    this.schoolName,
    required this.isActive,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phoneNumber,
    role,
    schoolId,
    schoolName,
    isActive,
    photoUrl,
    createdAt,
    updatedAt,
  ];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
    String? schoolId,
    String? schoolName,
    bool? isActive,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      isActive: isActive ?? this.isActive,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
