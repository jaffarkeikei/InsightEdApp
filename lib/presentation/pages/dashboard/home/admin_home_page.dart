import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/pages/students/add_student_page.dart';
import 'package:insighted/presentation/pages/teachers/add_teacher_page.dart';
import 'package:insighted/presentation/pages/classes/create_class_page.dart';
import 'package:insighted/presentation/widgets/dashboard_app_bar.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: ColorConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              Text(
                'Welcome back, Admin',
                style: TextStyle(
                  color: ColorConstants.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'School Management System Overview',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Quick Stats
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCardGrid(
                    title: 'Total Students',
                    value: '1,248',
                    icon: Icons.people,
                    color: ColorConstants.primaryColor,
                  ),
                  _buildStatCardGrid(
                    title: 'Total Teachers',
                    value: '86',
                    icon: Icons.school,
                    color: ColorConstants.primaryColor,
                  ),
                  _buildStatCardGrid(
                    title: 'Classes',
                    value: '42',
                    icon: Icons.class_outlined,
                    color: ColorConstants.primaryColor,
                  ),
                  _buildStatCardGrid(
                    title: 'Attendance',
                    value: '92%',
                    icon: Icons.check_circle_outline,
                    color: ColorConstants.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              _buildSectionCard(
                title: 'Quick Actions',
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    _buildActionButtonGrid(
                      label: 'Add Student',
                      icon: Icons.person_add,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddStudentPage(),
                          ),
                        );
                      },
                    ),
                    _buildActionButtonGrid(
                      label: 'Add Teacher',
                      icon: Icons.person_add_alt_1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddTeacherPage(),
                          ),
                        );
                      },
                    ),
                    _buildActionButtonGrid(
                      label: 'Create Class',
                      icon: Icons.add_box,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateClassPage(),
                          ),
                        );
                      },
                    ),
                    _buildActionButtonGrid(
                      label: 'Attendance',
                      icon: Icons.event_note,
                      onTap: () {},
                    ),
                    _buildActionButtonGrid(
                      label: 'Fees',
                      icon: Icons.payments_outlined,
                      onTap: () {},
                    ),
                    _buildActionButtonGrid(
                      label: 'Reports',
                      icon: Icons.assessment_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CBC Curriculum Overview
              _buildSectionCard(
                title: 'CBC Curriculum Status',
                trailing: _buildStatusBadge(
                  'Implemented',
                  ColorConstants.successColor,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildCurriculumLevelCard(
                      title: 'Upper Primary (Grades 4-6)',
                      subjects: [
                        'English',
                        'Kiswahili',
                        'Mathematics',
                        'Science and Technology',
                        'Social Studies',
                        'Religious Education',
                        'Creative Arts',
                        'Physical and Health Education',
                        'Agriculture',
                        'Home Science',
                      ],
                      teacherCount: 18,
                      studentCount: 423,
                    ),
                    const SizedBox(height: 16),
                    _buildCurriculumLevelCard(
                      title: 'Junior Secondary (Grades 7-9)',
                      subjects: [
                        'English',
                        'Kiswahili',
                        'Mathematics',
                        'Integrated Science',
                        'Health Education',
                        'Pre-Technical Education',
                        'Social Studies',
                        'Religious Education',
                        'Business Studies',
                        'Agriculture',
                        'Life Skills',
                        'Physical Education',
                      ],
                      teacherCount: 24,
                      studentCount: 386,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'View Curriculum Details',
                          style: TextStyle(
                            color: ColorConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Activity (simplified version)
              _buildSectionCard(
                title: 'Recent Activity',
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final activities = [
                      {
                        'user': 'You',
                        'action': 'added a new student',
                        'target': 'John Smith',
                        'time': '3 hours ago',
                        'icon': Icons.person_add,
                      },
                      {
                        'user': 'You',
                        'action': 'updated class schedule for',
                        'target': 'Grade 10',
                        'time': 'Yesterday',
                        'icon': Icons.schedule,
                      },
                      {
                        'user': 'You',
                        'action': 'generated report for',
                        'target': 'Term 2 Examinations',
                        'time': '2 days ago',
                        'icon': Icons.assessment,
                      },
                      {
                        'user': 'Ms. Johnson',
                        'action': 'submitted grades for',
                        'target': 'Class 8W',
                        'time': '3 days ago',
                        'icon': Icons.grading,
                      },
                      {
                        'user': 'System',
                        'action': 'completed database backup',
                        'target': '',
                        'time': '5 days ago',
                        'icon': Icons.backup,
                      },
                    ];

                    final activity = activities[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: ColorConstants.primaryColor
                                .withOpacity(0.1),
                            radius: 20,
                            child: Icon(
                              activity['icon'] as IconData,
                              color: ColorConstants.primaryColor,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: ColorConstants.primaryTextColor,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${activity['user']} ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: '${activity['action']} '),
                                      TextSpan(
                                        text: activity['target'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity['time'] as String,
                                  style: TextStyle(
                                    color: ColorConstants.secondaryTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.primaryColor,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardGrid({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: ColorConstants.primaryTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: ColorConstants.secondaryTextColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtonGrid({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: ColorConstants.primaryColor.withOpacity(0.1),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(icon, color: ColorConstants.primaryColor, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: ColorConstants.primaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCurriculumLevelCard({
    required String title,
    required List<String> subjects,
    required int teacherCount,
    required int studentCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ColorConstants.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.person,
                color: ColorConstants.secondaryTextColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '$studentCount Students',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.school,
                color: ColorConstants.secondaryTextColor,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '$teacherCount Teachers',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                subjects.map((subject) => _buildSubjectChip(subject)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorConstants.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ColorConstants.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

enum NotificationType { info, warning, alert }
