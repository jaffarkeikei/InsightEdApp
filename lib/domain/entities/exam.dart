import 'package:equatable/equatable.dart';

class Exam extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime examDate;
  final int term;
  final int academicYear;
  final double totalMarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exam({
    required this.id,
    required this.name,
    required this.description,
    required this.examDate,
    required this.term,
    required this.academicYear,
    required this.totalMarks,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    examDate,
    term,
    academicYear,
    totalMarks,
    createdAt,
    updatedAt,
  ];

  Exam copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? examDate,
    int? term,
    int? academicYear,
    double? totalMarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exam(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      examDate: examDate ?? this.examDate,
      term: term ?? this.term,
      academicYear: academicYear ?? this.academicYear,
      totalMarks: totalMarks ?? this.totalMarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
