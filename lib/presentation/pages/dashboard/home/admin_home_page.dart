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
              Row(
                children: [
                  _buildStatCard(
                    title: 'Total Students',
                    value: '1,248',
                    icon: Icons.people,
                    color: ColorConstants.primaryColor,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    title: 'Total Teachers',
                    value: '86',
                    icon: Icons.school,
                    color: ColorConstants.accentColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard(
                    title: 'Classes',
                    value: '42',
                    icon: Icons.class_outlined,
                    color: ColorConstants.warningColor,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    title: 'Attendance',
                    value: '92%',
                    icon: Icons.check_circle_outline,
                    color: ColorConstants.successColor,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.spaceAround,
                        spacing: 8,
                        runSpacing: 16,
                        children: [
                          _buildActionButton(
                            label: 'Add Student',
                            icon: Icons.person_add,
                            color: ColorConstants.primaryColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddStudentPage(),
                                ),
                              );
                            },
                            context: context,
                          ),
                          _buildActionButton(
                            label: 'Add Teacher',
                            icon: Icons.person_add_alt_1,
                            color: ColorConstants.accentColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddTeacherPage(),
                                ),
                              );
                            },
                            context: context,
                          ),
                          _buildActionButton(
                            label: 'Create Class',
                            icon: Icons.add_box,
                            color: ColorConstants.warningColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateClassPage(),
                                ),
                              );
                            },
                            context: context,
                          ),
                          _buildActionButton(
                            label: 'Attendance',
                            icon: Icons.event_note,
                            color: ColorConstants.successColor,
                            onTap: () {},
                            context: context,
                          ),
                          _buildActionButton(
                            label: 'Fees',
                            icon: Icons.payments_outlined,
                            color: ColorConstants.infoColor,
                            onTap: () {},
                            context: context,
                          ),
                          _buildActionButton(
                            label: 'Reports',
                            icon: Icons.assessment_outlined,
                            color: ColorConstants.errorColor,
                            onTap: () {},
                            context: context,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // CBC Curriculum Overview
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
                            'CBC Curriculum Status',
                            style: TextStyle(
                              color: ColorConstants.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstants.successColor.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: ColorConstants.successColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Implemented',
                                  style: TextStyle(
                                    color: ColorConstants.successColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                        color: ColorConstants.accentColor,
                      ),
                      const SizedBox(height: 12),
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
                        color: ColorConstants.primaryColor,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View Curriculum Details',
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Notifications
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
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
                            'Recent Notifications',
                            style: TextStyle(
                              color: ColorConstants.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Badge(
                            label: const Text('3'),
                            backgroundColor: ColorConstants.errorColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildNotificationItem(
                        title: 'System Update',
                        message: 'New system features have been installed',
                        time: '2 hours ago',
                        type: NotificationType.info,
                      ),
                      const Divider(),
                      _buildNotificationItem(
                        title: 'Fee Payment',
                        message: '15 students have pending fee payments',
                        time: 'Yesterday',
                        type: NotificationType.warning,
                      ),
                      const Divider(),
                      _buildNotificationItem(
                        title: 'Teacher Leave Request',
                        message:
                            'Mr. Johnson has requested leave for next week',
                        time: '2 days ago',
                        type: NotificationType.alert,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Recent Activity
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final activities = [
                            {
                              'user': 'You',
                              'action': 'added a new student',
                              'target': 'John Smith',
                              'time': '3 hours ago',
                              'icon': Icons.person_add,
                              'color': ColorConstants.primaryColor,
                            },
                            {
                              'user': 'You',
                              'action': 'updated class schedule for',
                              'target': 'Grade 10',
                              'time': 'Yesterday',
                              'icon': Icons.schedule,
                              'color': ColorConstants.accentColor,
                            },
                            {
                              'user': 'You',
                              'action': 'generated report for',
                              'target': 'Term 2 Examinations',
                              'time': '2 days ago',
                              'icon': Icons.assessment,
                              'color': ColorConstants.infoColor,
                            },
                            {
                              'user': 'Ms. Johnson',
                              'action': 'submitted grades for',
                              'target': 'Class 8W',
                              'time': '3 days ago',
                              'icon': Icons.grading,
                              'color': ColorConstants.successColor,
                            },
                            {
                              'user': 'System',
                              'action': 'completed database backup',
                              'target': '',
                              'time': '5 days ago',
                              'icon': Icons.backup,
                              'color': ColorConstants.warningColor,
                            },
                          ];

                          final activity = activities[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: (activity['color'] as Color)
                                  .withOpacity(0.2),
                              child: Icon(
                                activity['icon'] as IconData,
                                color: activity['color'] as Color,
                                size: 20,
                              ),
                            ),
                            title: RichText(
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
                            subtitle: Text(
                              activity['time'] as String,
                              style: TextStyle(
                                color: ColorConstants.secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {},
                              iconSize: 18,
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All Activity',
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 20,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    // Calculate the width based on available space
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth =
        (screenWidth - 80) / 3; // 3 buttons per row with padding

    return Container(
      width: buttonWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: color.withOpacity(0.1),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(icon, color: color, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: ColorConstants.primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required NotificationType type,
  }) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.info:
        icon = Icons.info_outline;
        color = ColorConstants.infoColor;
        break;
      case NotificationType.warning:
        icon = Icons.warning_amber_outlined;
        color = ColorConstants.warningColor;
        break;
      case NotificationType.alert:
        icon = Icons.notification_important_outlined;
        color = ColorConstants.errorColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 18,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumLevelCard({
    required String title,
    required List<String> subjects,
    required int teacherCount,
    required int studentCount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
                  const SizedBox(width: 8),
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
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                subjects
                    .map(
                      (subject) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subject,
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

enum NotificationType { info, warning, alert }
