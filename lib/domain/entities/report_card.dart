import 'package:equatable/equatable.dart';
import 'package:insighted/domain/entities/result.dart';

class ReportCard extends Equatable {
  final String id;
  final String studentId;
  final String studentName;
  final String studentNumber;
  final String gender;
  final String classId;
  final String className;
  final String grade;
  final String termName;
  final int term;
  final int academicYear;
  final DateTime reportDate;
  final List<Result> results;
  final double averageMark;
  final String? overallGrade;
  final int? position;
  final int? totalStudents;
  final String? teacherComments;
  final String? principalComments;
  final String? parentComments;
  final String? recommendations;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReportCard({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentNumber,
    required this.gender,
    required this.classId,
    required this.className,
    required this.grade,
    required this.termName,
    required this.term,
    required this.academicYear,
    required this.reportDate,
    required this.results,
    required this.averageMark,
    this.overallGrade,
    this.position,
    this.totalStudents,
    this.teacherComments,
    this.principalComments,
    this.parentComments,
    this.recommendations,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    studentName,
    studentNumber,
    gender,
    classId,
    className,
    grade,
    termName,
    term,
    academicYear,
    reportDate,
    results,
    averageMark,
    overallGrade,
    position,
    totalStudents,
    teacherComments,
    principalComments,
    parentComments,
    recommendations,
    createdAt,
    updatedAt,
  ];

  ReportCard copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentNumber,
    String? gender,
    String? classId,
    String? className,
    String? grade,
    String? termName,
    int? term,
    int? academicYear,
    DateTime? reportDate,
    List<Result>? results,
    double? averageMark,
    String? overallGrade,
    int? position,
    int? totalStudents,
    String? teacherComments,
    String? principalComments,
    String? parentComments,
    String? recommendations,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReportCard(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentNumber: studentNumber ?? this.studentNumber,
      gender: gender ?? this.gender,
      classId: classId ?? this.classId,
      className: className ?? this.className,
      grade: grade ?? this.grade,
      termName: termName ?? this.termName,
      term: term ?? this.term,
      academicYear: academicYear ?? this.academicYear,
      reportDate: reportDate ?? this.reportDate,
      results: results ?? this.results,
      averageMark: averageMark ?? this.averageMark,
      overallGrade: overallGrade ?? this.overallGrade,
      position: position ?? this.position,
      totalStudents: totalStudents ?? this.totalStudents,
      teacherComments: teacherComments ?? this.teacherComments,
      principalComments: principalComments ?? this.principalComments,
      parentComments: parentComments ?? this.parentComments,
      recommendations: recommendations ?? this.recommendations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
