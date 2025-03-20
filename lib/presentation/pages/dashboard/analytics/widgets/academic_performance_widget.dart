import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class AcademicPerformanceWidget extends StatelessWidget {
  final String period;

  const AcademicPerformanceWidget({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildSubjectPerformance(),
          const SizedBox(height: 24),
          _buildGradeTrends(),
          const SizedBox(height: 24),
          _buildTopStudents(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Academic Performance',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Detailed insights into student performance for $period',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectPerformance() {
    final subjects = [
      'Mathematics',
      'English',
      'Science',
      'Social Studies',
      'Kiswahili',
    ];

    final performances = [78, 85, 72, 81, 90];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance by Subject',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final colors = [
              ColorConstants.primaryColor,
              ColorConstants.accentColor,
              ColorConstants.warningColor,
              ColorConstants.infoColor,
              ColorConstants.successColor,
            ];

            return _buildSubjectPerformanceItem(
              subject: subjects[index],
              performance: performances[index],
              color: colors[index % colors.length],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubjectPerformanceItem({
    required String subject,
    required int performance,
    required Color color,
  }) {
    String grade;
    Color gradeColor;

    if (performance >= 90) {
      grade = 'A';
      gradeColor = ColorConstants.successColor;
    } else if (performance >= 80) {
      grade = 'B';
      gradeColor = ColorConstants.infoColor;
    } else if (performance >= 70) {
      grade = 'C';
      gradeColor = ColorConstants.warningColor;
    } else if (performance >= 60) {
      grade = 'D';
      gradeColor = Colors.orange;
    } else {
      grade = 'F';
      gradeColor = ColorConstants.errorColor;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Icon(Icons.book, color: color, size: 20)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Average Score: $performance%',
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorConstants.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    grade,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: gradeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: performance / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(3),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildGradeTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grade Distribution',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 240,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildGradeBar('A', 15, ColorConstants.successColor),
                    _buildGradeBar('B', 30, ColorConstants.infoColor),
                    _buildGradeBar('C', 35, ColorConstants.warningColor),
                    _buildGradeBar('D', 12, Colors.orange),
                    _buildGradeBar('F', 8, ColorConstants.errorColor),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Students: 100',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.secondaryTextColor,
                    ),
                  ),
                  Text(
                    'Average Grade: B-',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.infoColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGradeBar(String grade, int percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: ColorConstants.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: percentage * 1.6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          grade,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTopStudents() {
    final students = [
      {'name': 'Esther Wambui', 'class': 'Grade 7', 'grade': 'A', 'score': 95},
      {'name': 'Daniel Ochieng', 'class': 'Grade 4', 'grade': 'A', 'score': 94},
      {'name': 'Faith Mwangi', 'class': 'Grade 9', 'grade': 'A', 'score': 92},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Performing Students',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final student = students[index];
            return _buildStudentItem(
              name: student['name'] as String,
              className: student['class'] as String,
              grade: student['grade'] as String,
              score: student['score'] as int,
              rank: index + 1,
            );
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'View All Students',
              style: TextStyle(
                color: ColorConstants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentItem({
    required String name,
    required String className,
    required String grade,
    required int score,
    required int rank,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  rank == 1
                      ? Colors.amber.withOpacity(0.2)
                      : rank == 2
                      ? Colors.grey.shade300
                      : Colors.brown.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      rank == 1
                          ? Colors.amber
                          : rank == 2
                          ? Colors.grey.shade700
                          : Colors.brown,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  className,
                  style: TextStyle(
                    fontSize: 13,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorConstants.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  grade,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.successColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConstants.successColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
