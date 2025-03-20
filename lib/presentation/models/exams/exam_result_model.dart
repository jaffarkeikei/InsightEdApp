class ExamResult {
  final String examId;
  final String examTitle;
  final String studentId;
  final String studentName;
  final Map<String, int> subjectScores; // key: subject name, value: score
  final int totalScore;
  final int position;

  const ExamResult({
    required this.examId,
    required this.examTitle,
    required this.studentId,
    required this.studentName,
    required this.subjectScores,
    required this.totalScore,
    required this.position,
  });

  // Factory method to create from JSON
  factory ExamResult.fromJson(Map<String, dynamic> json) {
    final subjectScores = Map<String, int>.from(json['subjectScores']);
    return ExamResult(
      examId: json['examId'],
      examTitle: json['examTitle'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      subjectScores: subjectScores,
      totalScore: json['totalScore'],
      position: json['position'],
    );
  }
}

// Model for the exam with its title and related info
class Exam {
  final String id;
  final String title;
  final String description;
  final String date;
  final String term;
  final String academicYear;
  final List<String> subjects;

  const Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.term,
    required this.academicYear,
    required this.subjects,
  });
}
