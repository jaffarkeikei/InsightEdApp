import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/utils/subject_utils.dart';
import 'package:insighted/presentation/models/exams/exam_result_model.dart';

class ExamResultsTable extends StatelessWidget {
  final List<ExamResult> results;
  final List<String> subjects;
  final Color classColor;

  const ExamResultsTable({
    super.key,
    required this.results,
    required this.subjects,
    required this.classColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) => classColor.withOpacity(0.1),
          ),
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: classColor,
          ),
          columns: [
            const DataColumn(label: Text('#'), numeric: true),
            const DataColumn(label: Text('Name')),
            ...subjects.map(
              (subject) => DataColumn(
                label: Text(SubjectUtils.getAbbreviation(subject)),
                numeric: true,
                tooltip: subject, // Show full subject name on hover
              ),
            ),
            const DataColumn(label: Text('Total'), numeric: true),
            const DataColumn(label: Text('Pos'), numeric: true),
          ],
          rows:
              results.asMap().entries.map((entry) {
                final index = entry.key;
                final result = entry.value;

                return DataRow(
                  color:
                      index % 2 == 0
                          ? null
                          : WidgetStateProperty.all(Colors.grey.shade50),
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            result.studentName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            result.studentId,
                            style: TextStyle(
                              color: ColorConstants.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...subjects.map((subject) {
                      final score = result.subjectScores[subject] ?? 0;
                      // Color the score based on performance
                      Color scoreColor = Colors.black;
                      if (score >= 80) {
                        scoreColor = Colors.green;
                      } else if (score >= 60) {
                        scoreColor = Colors.orange;
                      } else if (score < 50) {
                        scoreColor = Colors.red;
                      }

                      return DataCell(
                        Text(
                          '$score',
                          style: TextStyle(
                            color: scoreColor,
                            fontWeight:
                                score >= 80
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                    DataCell(
                      Text(
                        '${result.totalScore}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPositionColor(
                            result.position,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${result.position}',
                          style: TextStyle(
                            color: _getPositionColor(result.position),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  // Return color based on position in class
  Color _getPositionColor(int position) {
    if (position <= 3) {
      return Colors.green;
    } else if (position <= 10) {
      return Colors.blue;
    } else if (position <= 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
