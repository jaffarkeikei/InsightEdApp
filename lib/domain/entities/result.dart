import 'package:equatable/equatable.dart';

class Result extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final String examId;
  final String examName;
  final String subjectId;
  final String subjectName;
  final String classId;
  final String className;
  final double marks;
  final double? outOf;
  final String? grade;
  final String? comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Result({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.examId,
    required this.examName,
    required this.subjectId,
    required this.subjectName,
    required this.classId,
    required this.className,
    required this.marks,
    this.outOf,
    this.grade,
    this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    studentName,
    examId,
    examName,
    subjectId,
    subjectName,
    classId,
    className,
    marks,
    outOf,
    grade,
    comments,
    createdAt,
    updatedAt,
  ];

  Result copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? examId,
    String? examName,
    String? subjectId,
    String? subjectName,
    String? classId,
    String? className,
    double? marks,
    double? outOf,
    String? grade,
    String? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Result(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      examId: examId ?? this.examId,
      examName: examName ?? this.examName,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      marks: marks ?? this.marks,
      outOf: outOf ?? this.outOf,
      grade: grade ?? this.grade,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
