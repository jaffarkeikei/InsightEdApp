import 'package:flutter/material.dart';

class ClassModel {
  final String id;
  final String name;
  final String section;
  final int studentCount;
  final int teacherCount;
  final String classTeacher;
  final List<String> subjects;
  final String level;
  final Color color;

  ClassModel({
    required this.id,
    required this.name,
    required this.section,
    required this.studentCount,
    required this.teacherCount,
    required this.classTeacher,
    required this.subjects,
    required this.level,
    required this.color,
  });
}
