import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? description;
  final int? maxMarks;
  final double? passMark;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subject({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.maxMarks,
    this.passMark,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    description,
    maxMarks,
    passMark,
    createdAt,
    updatedAt,
  ];

  Subject copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    int? maxMarks,
    double? passMark,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      maxMarks: maxMarks ?? this.maxMarks,
      passMark: passMark ?? this.passMark,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
