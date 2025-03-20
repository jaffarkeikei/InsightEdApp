import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class TeacherPerformanceWidget extends StatelessWidget {
  final String period;

  const TeacherPerformanceWidget({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildPerformanceOverview(),
          const SizedBox(height: 24),
          _buildTopTeachers(),
          const SizedBox(height: 24),
          _buildSubjectPerformance(),
          const SizedBox(height: 24),
          _buildTeacherImprovementAreas(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Teacher Performance',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Teacher effectiveness and impact metrics for $period',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceOverview() {
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
          Text(
            'Overall Teacher Performance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.primaryTextColor,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPerformanceMetric(
                icon: Icons.auto_graph,
                label: 'Student\nAchievement',
                value: '85%',
                color: ColorConstants.primaryColor,
              ),
              _buildPerformanceMetric(
                icon: Icons.timer,
                label: 'Class\nAttendance',
                value: '93%',
                color: ColorConstants.successColor,
              ),
              _buildPerformanceMetric(
                icon: Icons.people,
                label: 'Student\nEngagement',
                value: '78%',
                color: ColorConstants.warningColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorConstants.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: ColorConstants.accentColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Overall teacher performance has improved by 3.2% compared to the previous term',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTopTeachers() {
    final teachers = [
      {
        'name': 'Jane Smith',
        'subject': 'Mathematics',
        'rating': 4.8,
        'performance': 95,
      },
      {
        'name': 'John Doe',
        'subject': 'English',
        'rating': 4.7,
        'performance': 93,
      },
      {
        'name': 'Sarah Johnson',
        'subject': 'Science',
        'rating': 4.6,
        'performance': 91,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Performing Teachers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teachers.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return _buildTeacherItem(
              name: teacher['name'] as String,
              subject: teacher['subject'] as String,
              rating: teacher['rating'] as double,
              performance: teacher['performance'] as int,
              rank: index + 1,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTeacherItem({
    required String name,
    required String subject,
    required double rating,
    required int performance,
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  rank == 1
                      ? ColorConstants.primaryColor.withOpacity(0.1)
                      : rank == 2
                      ? ColorConstants.infoColor.withOpacity(0.1)
                      : ColorConstants.successColor.withOpacity(0.1),
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
                          ? ColorConstants.primaryColor
                          : rank == 2
                          ? ColorConstants.infoColor
                          : ColorConstants.successColor,
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
                const SizedBox(height: 4),
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 13,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$performance% performance',
                style: TextStyle(
                  fontSize: 12,
                  color: ColorConstants.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance by Subject',
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
                  Icons.pie_chart,
                  size: 48,
                  color: ColorConstants.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Subject performance distribution',
                  style: TextStyle(color: ColorConstants.secondaryTextColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'In a real application, this would display a pie chart',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorConstants.secondaryTextColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSubjectPerformanceItem(
                subject: 'Mathematics',
                performance: 88,
                color: ColorConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSubjectPerformanceItem(
                subject: 'English',
                performance: 92,
                color: ColorConstants.infoColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSubjectPerformanceItem(
                subject: 'Science',
                performance: 83,
                color: ColorConstants.warningColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSubjectPerformanceItem(
                subject: 'Social Studies',
                performance: 85,
                color: ColorConstants.successColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectPerformanceItem({
    required String subject,
    required int performance,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            subject,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '$performance%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherImprovementAreas() {
    final areas = [
      {
        'title': 'Student Engagement',
        'description': 'Interactive teaching methods to improve engagement',
        'icon': Icons.people,
      },
      {
        'title': 'Technology Integration',
        'description': 'Better use of educational technology in classroom',
        'icon': Icons.computer,
      },
      {
        'title': 'Assessment Methods',
        'description': 'Diversify assessment techniques for better evaluation',
        'icon': Icons.assessment,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Areas for Improvement',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: areas.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final area = areas[index];
            return _buildImprovementAreaItem(
              title: area['title'] as String,
              description: area['description'] as String,
              icon: area['icon'] as IconData,
            );
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.article, size: 20),
            label: const Text('Generate Detailed Report'),
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementAreaItem({
    required String title,
    required String description,
    required IconData icon,
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
              color: ColorConstants.infoColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorConstants.infoColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: ColorConstants.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ColorConstants.secondaryTextColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
