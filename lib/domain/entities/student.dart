import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String name;
  final String studentNumber;
  final String gender;
  final String classId;
  final String className;
  final String? photoUrl;
  final DateTime dateOfBirth;
  final String? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Student({
    required this.id,
    required this.name,
    required this.studentNumber,
    required this.gender,
    required this.classId,
    required this.className,
    this.photoUrl,
    required this.dateOfBirth,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    studentNumber,
    gender,
    classId,
    className,
    photoUrl,
    dateOfBirth,
    parentId,
    createdAt,
    updatedAt,
  ];

  Student copyWith({
    String? id,
    String? name,
    String? studentNumber,
    String? gender,
    String? classId,
    String? className,
    String? photoUrl,
    DateTime? dateOfBirth,
    String? parentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      studentNumber: studentNumber ?? this.studentNumber,
      gender: gender ?? this.gender,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      photoUrl: photoUrl ?? this.photoUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
