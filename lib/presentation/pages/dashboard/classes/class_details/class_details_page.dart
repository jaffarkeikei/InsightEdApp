import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/models/class_model.dart';
import 'package:insighted/presentation/pages/dashboard/exams/exam_results_page.dart';

class ClassDetailsPage extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailsPage({super.key, required this.classModel});

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.classModel.name} ${widget.classModel.section}'),
        backgroundColor: widget.classModel.color,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Students'),
            Tab(text: 'Teachers'),
            Tab(text: 'Exams'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildStudentsTab(),
          _buildTeachersTab(),
          _buildExamsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.classModel.color,
        child: const Icon(Icons.edit),
        onPressed: () {
          // Edit class details
        },
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Class Information',
            content: [
              _buildInfoRow(
                'Class Name',
                '${widget.classModel.name} ${widget.classModel.section}',
              ),
              _buildInfoRow('Education Level', widget.classModel.level),
              _buildInfoRow('Class Teacher', widget.classModel.classTeacher),
              _buildInfoRow(
                'Number of Students',
                widget.classModel.studentCount.toString(),
              ),
              _buildInfoRow(
                'Number of Teachers',
                widget.classModel.teacherCount.toString(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Subjects',
            content:
                widget.classModel.subjects.map((subject) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.classModel.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.book,
                            color: widget.classModel.color,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          subject,
                          style: TextStyle(
                            color: ColorConstants.primaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Class Schedule',
            content: [
              _buildScheduleItem('Monday', '8:00 AM - 4:00 PM'),
              _buildScheduleItem('Tuesday', '8:00 AM - 4:00 PM'),
              _buildScheduleItem('Wednesday', '8:00 AM - 4:00 PM'),
              _buildScheduleItem('Thursday', '8:00 AM - 4:00 PM'),
              _buildScheduleItem('Friday', '8:00 AM - 3:00 PM'),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Performance Metrics',
            content: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.classModel.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPerformanceMetric(
                          'Average Score',
                          '72%',
                          Icons.score,
                        ),
                        _buildPerformanceMetric(
                          'Attendance',
                          '92%',
                          Icons.calendar_today,
                        ),
                        _buildPerformanceMetric(
                          'Completion',
                          '88%',
                          Icons.assignment_turned_in,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Class is performing well overall. Attendance has improved by 5% since last term.',
                            style: TextStyle(
                              color: ColorConstants.secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, color: widget.classModel.color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: ColorConstants.primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: ColorConstants.secondaryTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              color: ColorConstants.primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: ColorConstants.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: ColorConstants.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: ColorConstants.primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> content,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: ColorConstants.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsTab() {
    // Mock student data
    final students = [
      {'name': 'John Smith', 'id': '001', 'average': '85%'},
      {'name': 'Emily Johnson', 'id': '002', 'average': '92%'},
      {'name': 'Michael Brown', 'id': '003', 'average': '78%'},
      {'name': 'Jessica Davis', 'id': '004', 'average': '89%'},
      {'name': 'David Wilson', 'id': '005', 'average': '75%'},
      {'name': 'Sarah Martinez', 'id': '006', 'average': '91%'},
      {'name': 'James Taylor', 'id': '007', 'average': '82%'},
      {'name': 'Jennifer Anderson', 'id': '008', 'average': '88%'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student['name']!),
                subtitle: Text(student['id']!),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.classModel.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    student['average']!,
                    style: TextStyle(
                      color: widget.classModel.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  // View student details
                },
                leading: CircleAvatar(
                  backgroundColor: widget.classModel.color.withOpacity(0.1),
                  child: Text(
                    student['name']!.substring(0, 1),
                    style: TextStyle(
                      color: widget.classModel.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTeachersTab() {
    // Mock teacher data
    final teachers = [
      {
        'name': 'Mrs. Jane Smith',
        'subject': 'Mathematics',
        'experience': '8 years',
      },
      {
        'name': 'Mr. Robert Johnson',
        'subject': 'English',
        'experience': '12 years',
      },
      {
        'name': 'Ms. Sarah Williams',
        'subject': 'Science',
        'experience': '5 years',
      },
      {
        'name': 'Mr. David Brown',
        'subject': 'Social Studies',
        'experience': '10 years',
      },
      {'name': 'Mrs. Emily Davis', 'subject': 'Art', 'experience': '7 years'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.classModel.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: widget.classModel.color,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher['name']!,
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Subject: ${teacher['subject']}',
                        style: TextStyle(
                          color: ColorConstants.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Experience: ${teacher['experience']}',
                        style: TextStyle(
                          color: ColorConstants.secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // View teacher details
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExamsTab() {
    // Mock exam data
    final exams = [
      {
        'id': 'E001',
        'title': 'Mid-Term Examination',
        'date': '15 May 2023',
        'status': 'Upcoming',
        'subjects': ['Mathematics', 'English', 'Science', 'Social Studies'],
      },
      {
        'id': 'E002',
        'title': 'Weekly Quiz - Week 8',
        'date': '5 May 2023',
        'status': 'Completed',
        'subjects': ['Mathematics', 'English'],
      },
      {
        'id': 'E003',
        'title': 'Weekly Quiz - Week 7',
        'date': '28 April 2023',
        'status': 'Completed',
        'subjects': ['Science', 'Social Studies'],
      },
      {
        'id': 'E004',
        'title': 'End of Term Examination',
        'date': '15 July 2023',
        'status': 'Upcoming',
        'subjects': [
          'Mathematics',
          'English',
          'Science',
          'Social Studies',
          'Art',
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        final isUpcoming = exam['status'] == 'Upcoming';
        final examId = exam['id'] as String? ?? '';
        final title = exam['title'] as String? ?? '';
        final status = exam['status'] as String? ?? '';
        final date = exam['date'] as String? ?? '';
        final subjects = exam['subjects'] as List<dynamic>? ?? [];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: ColorConstants.primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUpcoming
                                ? ColorConstants.warningColor.withOpacity(0.1)
                                : ColorConstants.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color:
                              isUpcoming
                                  ? ColorConstants.warningColor
                                  : ColorConstants.successColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: $date',
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Subjects:',
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      subjects.map((subject) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.classModel.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subject.toString(),
                            style: TextStyle(
                              color: widget.classModel.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                if (isUpcoming)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.classModel.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Schedule'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to exam results page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ExamResultsPage(
                                examId: examId,
                                examTitle: title,
                                classId: widget.classModel.id,
                                className:
                                    '${widget.classModel.name} ${widget.classModel.section}',
                                classColor: widget.classModel.color,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.classModel.color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Results'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
