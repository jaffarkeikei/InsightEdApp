import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class ClassComparisonWidget extends StatefulWidget {
  final String period;

  const ClassComparisonWidget({super.key, required this.period});

  @override
  State<ClassComparisonWidget> createState() => _ClassComparisonWidgetState();
}

class _ClassComparisonWidgetState extends State<ClassComparisonWidget> {
  final List<String> _selectedClasses = ['Grade 4', 'Grade 7'];
  final List<String> _availableClasses = [
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7',
    'Grade 8',
    'Grade 9',
  ];
  String _selectedSubject = 'All Subjects';
  final List<String> _subjects = [
    'All Subjects',
    'Mathematics',
    'English',
    'Science',
    'Social Studies',
    'Kiswahili',
  ];

  void _toggleClassSelection(String className) {
    setState(() {
      if (_selectedClasses.contains(className)) {
        if (_selectedClasses.length > 1) {
          _selectedClasses.remove(className);
        }
      } else {
        if (_selectedClasses.length < 3) {
          _selectedClasses.add(className);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select maximum 3 classes for comparison'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void _changeSubject(String? subject) {
    if (subject != null && subject != _selectedSubject) {
      setState(() {
        _selectedSubject = subject;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildComparisonSettings(),
          const SizedBox(height: 24),
          _buildPerformanceComparison(),
          const SizedBox(height: 24),
          _buildAttendanceComparison(),
          const SizedBox(height: 24),
          _buildTeacherEffectivenessComparison(),
          const SizedBox(height: 24),
          _buildComparisonInsights(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Class Comparison',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Compare performance metrics across classes for ${widget.period}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparison Settings',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Classes (Max 3)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _availableClasses
                    .map(
                      (className) => FilterChip(
                        label: Text(className),
                        selected: _selectedClasses.contains(className),
                        onSelected: (_) => _toggleClassSelection(className),
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: ColorConstants.primaryColor.withOpacity(
                          0.2,
                        ),
                        checkmarkColor: ColorConstants.primaryColor,
                        labelStyle: TextStyle(
                          color:
                              _selectedClasses.contains(className)
                                  ? ColorConstants.primaryColor
                                  : Colors.black87,
                          fontWeight:
                              _selectedClasses.contains(className)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Subject:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedSubject,
                  isExpanded: true,
                  underline: Container(height: 1, color: Colors.grey.shade300),
                  items:
                      _subjects
                          .map(
                            (subject) => DropdownMenuItem<String>(
                              value: subject,
                              child: Text(subject),
                            ),
                          )
                          .toList(),
                  onChanged: _changeSubject,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceComparison() {
    final colors = [
      ColorConstants.primaryColor,
      ColorConstants.infoColor,
      ColorConstants.warningColor,
    ];

    final performanceData = {'Grade 4': 80, 'Grade 7': 85};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Academic Performance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 48,
                        color: ColorConstants.primaryColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Performance comparison chart',
                        style: TextStyle(
                          color: ColorConstants.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'In a real application, this would display a comparison chart',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.secondaryTextColor.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    _selectedClasses.map((className) {
                      final index = _selectedClasses.indexOf(className);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors[index],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$className (${performanceData[className]}%)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Attendance Comparison',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAttendanceCard(
                className: 'Grade 4',
                attendance: 92,
                color: ColorConstants.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAttendanceCard(
                className: 'Grade 7',
                attendance: 88,
                color: ColorConstants.infoColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttendanceCard({
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
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            className,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      value: attendance / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$attendance%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Attendance Rate',
            style: TextStyle(
              fontSize: 12,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherEffectivenessComparison() {
    final effectivenessData = [
      {
        'class': 'Grade 4',
        'effectiveness': 87,
        'color': ColorConstants.primaryColor,
      },
      {
        'class': 'Grade 7',
        'effectiveness': 92,
        'color': ColorConstants.infoColor,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Teacher Effectiveness',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: effectivenessData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final data = effectivenessData[index];
            return _buildEffectivenessItem(
              className: data['class'] as String,
              effectiveness: data['effectiveness'] as int,
              color: data['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEffectivenessItem({
    required String className,
    required int effectiveness,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
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
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(Icons.school, color: color)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    className,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Teacher Effectiveness',
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorConstants.secondaryTextColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$effectiveness%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: effectiveness / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(3),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonInsights() {
    final insights = [
      {
        'title': 'Performance Difference',
        'description': 'Grade 7 outperforms Grade 4 by 5% in average scores',
        'icon': Icons.trending_up,
      },
      {
        'title': 'Attendance Difference',
        'description': 'Grade 4 has 4% higher attendance rate than Grade 7',
        'icon': Icons.event_available,
      },
      {
        'title': 'Teacher Effectiveness',
        'description': 'Grade 7 teachers show 5% higher effectiveness rating',
        'icon': Icons.person,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Insights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: insights.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final insight = insights[index];
            return _buildInsightItem(
              title: insight['title'] as String,
              description: insight['description'] as String,
              icon: insight['icon'] as IconData,
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
            icon: const Icon(Icons.description, size: 20),
            label: const Text('Generate Detailed Comparison Report'),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem({
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
            color: const Color.fromARGB(252, 252, 252, 252).withOpacity(0.1),
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
              color: ColorConstants.accentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorConstants.accentColor),
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
        ],
      ),
    );
  }
}
