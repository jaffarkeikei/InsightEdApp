import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class AttendanceAnalyticsWidget extends StatelessWidget {
  final String period;

  const AttendanceAnalyticsWidget({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildAttendanceOverview(),
          const SizedBox(height: 24),
          _buildAttendanceByClass(),
          const SizedBox(height: 24),
          _buildAttendanceTrends(),
          const SizedBox(height: 24),
          _buildLowAttendanceStudents(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Attendance patterns and insights for $period',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '87%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+2.3%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Average Attendance Rate',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Compared to previous $period',
            style: TextStyle(
              fontSize: 12,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttendanceMetric(
                label: 'Present',
                value: '87%',
                color: ColorConstants.successColor,
              ),
              _buildAttendanceMetric(
                label: 'Absent',
                value: '8%',
                color: ColorConstants.errorColor,
              ),
              _buildAttendanceMetric(
                label: 'Late',
                value: '5%',
                color: ColorConstants.warningColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceMetric({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceByClass() {
    final classes = [
      {'name': 'Grade 4', 'attendance': 92},
      {'name': 'Grade 5', 'attendance': 87},
      {'name': 'Grade 6', 'attendance': 85},
      {'name': 'Grade 7', 'attendance': 88},
      {'name': 'Grade 8', 'attendance': 83},
      {'name': 'Grade 9', 'attendance': 80},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendance by Class',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final classData = classes[index];
            Color color;

            final attendance = classData['attendance'] as int;
            if (attendance >= 90) {
              color = ColorConstants.successColor;
            } else if (attendance >= 85) {
              color = ColorConstants.infoColor;
            } else if (attendance >= 80) {
              color = ColorConstants.warningColor;
            } else {
              color = ColorConstants.errorColor;
            }

            return _buildClassAttendanceCard(
              className: classData['name'] as String,
              attendance: attendance,
              color: color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildClassAttendanceCard({
    required String className,
    required int attendance,
    required Color color,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                className,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.people_outline, color: color, size: 20),
            ],
          ),
          const Spacer(),
          Text(
            '$attendance%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: attendance / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(3),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendance Trends',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart,
                  size: 48,
                  color: ColorConstants.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Attendance trend visualization',
                  style: TextStyle(color: ColorConstants.secondaryTextColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'In a real application, this would display a trend chart',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorConstants.secondaryTextColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLowAttendanceStudents() {
    final students = [
      {
        'name': 'John Kamau',
        'class': 'Grade 8',
        'attendance': '70%',
        'absences': 12,
      },
      {
        'name': 'Susan Njeri',
        'class': 'Grade 7',
        'attendance': '75%',
        'absences': 10,
      },
      {
        'name': 'Peter Wekesa',
        'class': 'Grade 9',
        'attendance': '76%',
        'absences': 9,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Students with Low Attendance',
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
            return _buildLowAttendanceStudentItem(
              name: student['name'] as String,
              className: student['class'] as String,
              attendance: student['attendance'] as String,
              absences: student['absences'] as int,
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

  Widget _buildLowAttendanceStudentItem({
    required String name,
    required String className,
    required String attendance,
    required int absences,
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
              color: ColorConstants.warningColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.warning_amber_rounded,
                color: ColorConstants.warningColor,
                size: 20,
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
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                attendance,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.errorColor,
                ),
              ),
              Text(
                '$absences absences',
                style: TextStyle(
                  fontSize: 12,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
