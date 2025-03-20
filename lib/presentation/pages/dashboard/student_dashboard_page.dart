import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const StudentHomePage(),
    const CoursesPage(),
    const AssignmentsPage(),
    const StudentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: ColorConstants.primaryColor,
        unselectedItemColor: ColorConstants.secondaryTextColor,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
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
                'Welcome back, Student!',
                style: TextStyle(
                  color: ColorConstants.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here\'s your learning summary',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Progress Overview
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
                            'CBC Subjects Performance',
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
                              color: ColorConstants.primaryColor.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Grade 7',
                              style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildProgressIndicator(
                              title: 'Mathematics',
                              percentage: 0.85,
                              color: ColorConstants.primaryColor,
                            ),
                            const SizedBox(width: 16),
                            _buildProgressIndicator(
                              title: 'English',
                              percentage: 0.92,
                              color: ColorConstants.successColor,
                            ),
                            const SizedBox(width: 16),
                            _buildProgressIndicator(
                              title: 'Kiswahili',
                              percentage: 0.78,
                              color: ColorConstants.accentColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildProgressIndicator(
                              title: 'Int. Science',
                              percentage: 0.75,
                              color: ColorConstants.warningColor,
                            ),
                            const SizedBox(width: 16),
                            _buildProgressIndicator(
                              title: 'Social Studies',
                              percentage: 0.88,
                              color: ColorConstants.infoColor,
                            ),
                            const SizedBox(width: 16),
                            _buildProgressIndicator(
                              title: 'Agriculture',
                              percentage: 0.81,
                              color: ColorConstants.errorColor,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View All Subjects',
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

              // Due Assignments
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
                            'Due Assignments',
                            style: TextStyle(
                              color: ColorConstants.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '3 Pending',
                            style: TextStyle(
                              color: ColorConstants.errorColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAssignmentItem(
                        subject: 'Mathematics',
                        title: 'Quadratic Equations',
                        dueDate: 'Due Tomorrow',
                        color: ColorConstants.primaryColor,
                        urgency: 'High',
                      ),
                      const SizedBox(height: 12),
                      _buildAssignmentItem(
                        subject: 'English',
                        title: 'Essay on Shakespeare',
                        dueDate: 'Due in 3 days',
                        color: ColorConstants.infoColor,
                        urgency: 'Medium',
                      ),
                      const SizedBox(height: 12),
                      _buildAssignmentItem(
                        subject: 'Physics',
                        title: 'Lab Report - Electricity',
                        dueDate: 'Due next week',
                        color: ColorConstants.accentColor,
                        urgency: 'Low',
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

              // This Week's Schedule
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
                        'This Week\'s Schedule',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildDaySchedule(
                              day: 'Mon',
                              isActive: true,
                              lessons: [
                                [
                                  '08:00',
                                  'Mathematics',
                                  ColorConstants.primaryColor,
                                ],
                                ['10:00', 'English', ColorConstants.infoColor],
                                [
                                  '13:00',
                                  'Physics',
                                  ColorConstants.accentColor,
                                ],
                              ],
                            ),
                            const SizedBox(width: 16),
                            _buildDaySchedule(
                              day: 'Tue',
                              isActive: false,
                              lessons: [
                                [
                                  '09:00',
                                  'History',
                                  ColorConstants.warningColor,
                                ],
                                [
                                  '11:00',
                                  'Biology',
                                  ColorConstants.successColor,
                                ],
                                ['14:00', 'Art', ColorConstants.errorColor],
                              ],
                            ),
                            const SizedBox(width: 16),
                            _buildDaySchedule(
                              day: 'Wed',
                              isActive: false,
                              lessons: [
                                [
                                  '08:00',
                                  'Chemistry',
                                  ColorConstants.infoColor,
                                ],
                                [
                                  '10:00',
                                  'Geography',
                                  ColorConstants.primaryColor,
                                ],
                                ['13:00', 'Music', ColorConstants.accentColor],
                              ],
                            ),
                            const SizedBox(width: 16),
                            _buildDaySchedule(
                              day: 'Thu',
                              isActive: false,
                              lessons: [
                                ['09:00', 'Physics', ColorConstants.errorColor],
                                [
                                  '11:00',
                                  'Mathematics',
                                  ColorConstants.primaryColor,
                                ],
                                ['14:00', 'English', ColorConstants.infoColor],
                              ],
                            ),
                            const SizedBox(width: 16),
                            _buildDaySchedule(
                              day: 'Fri',
                              isActive: false,
                              lessons: [
                                [
                                  '08:00',
                                  'Biology',
                                  ColorConstants.successColor,
                                ],
                                ['10:00', 'P.E.', ColorConstants.warningColor],
                                [
                                  '13:00',
                                  'Computer',
                                  ColorConstants.accentColor,
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Full Schedule',
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

              // Performance Summary
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
                        'Performance Summary',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPerformanceItem(
                        subject: 'Mathematics',
                        grade: 'A',
                        trend: 'Improving',
                        color: ColorConstants.successColor,
                      ),
                      const Divider(),
                      _buildPerformanceItem(
                        subject: 'Science',
                        grade: 'B+',
                        trend: 'Stable',
                        color: ColorConstants.infoColor,
                      ),
                      const Divider(),
                      _buildPerformanceItem(
                        subject: 'English',
                        grade: 'B',
                        trend: 'Needs Attention',
                        color: ColorConstants.warningColor,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Full Report',
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
    );
  }

  Widget _buildProgressIndicator({
    required String title,
    required double percentage,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '${(percentage * 100).toInt()}%',
                    style: TextStyle(
                      color: ColorConstants.primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
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

  Widget _buildAssignmentItem({
    required String subject,
    required String title,
    required String dueDate,
    required Color color,
    required String urgency,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      urgency == 'High'
                          ? ColorConstants.errorColor.withOpacity(0.1)
                          : urgency == 'Medium'
                          ? ColorConstants.warningColor.withOpacity(0.1)
                          : ColorConstants.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  urgency,
                  style: TextStyle(
                    color:
                        urgency == 'High'
                            ? ColorConstants.errorColor
                            : urgency == 'Medium'
                            ? ColorConstants.warningColor
                            : ColorConstants.successColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dueDate,
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySchedule({
    required String day,
    required bool isActive,
    required List<List<dynamic>> lessons,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isActive
                ? ColorConstants.primaryColor.withOpacity(0.1)
                : Colors.white,
        border: Border.all(
          color: isActive ? ColorConstants.primaryColor : Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color:
                  isActive
                      ? ColorConstants.primaryColor
                      : ColorConstants.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...lessons
              .map(
                (lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Text(
                        lesson[0],
                        style: TextStyle(
                          color: ColorConstants.secondaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (lesson[2] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lesson[1],
                          style: TextStyle(
                            color: lesson[2] as Color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              ,
        ],
      ),
    );
  }

  Widget _buildPerformanceItem({
    required String subject,
    required String grade,
    required String trend,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              subject,
              style: TextStyle(
                color: ColorConstants.primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                grade,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              trend,
              style: TextStyle(
                color:
                    trend == 'Improving'
                        ? ColorConstants.successColor
                        : trend == 'Stable'
                        ? ColorConstants.infoColor
                        : ColorConstants.warningColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: const Center(child: Text('Courses Page Content')),
    );
  }
}

class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text('Assignments Page Content')),
    );
  }
}

class StudentProfilePage extends StatelessWidget {
  const StudentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text('Student Profile Page Content')),
    );
  }
}
