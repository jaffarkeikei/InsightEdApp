import 'package:equatable/equatable.dart';

class ClassGroup extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String grade;
  final String? teacherId;
  final String? teacherName;
  final int academicYear;
  final int term;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClassGroup({
    required this.id,
    required this.name,
    this.description,
    required this.grade,
    this.teacherId,
    this.teacherName,
    required this.academicYear,
    required this.term,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    grade,
    teacherId,
    teacherName,
    academicYear,
    term,
    createdAt,
    updatedAt,
  ];

  ClassGroup copyWith({
    String? id,
    String? name,
    String? description,
    String? grade,
    String? teacherId,
    String? teacherName,
    int? academicYear,
    int? term,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      grade: grade ?? this.grade,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      academicYear: academicYear ?? this.academicYear,
      term: term ?? this.term,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
