import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TeacherHomePage(),
    const ClassesPage(),
    const ReportsPage(),
    const ProfilePage(),
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
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Reports',
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

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
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
                'Welcome back, Teacher!',
                style: TextStyle(
                  color: ColorConstants.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Here\'s what\'s happening today',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 16,
                ),
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
                      Row(
                        children: [
                          _buildActionButton(
                            icon: Icons.add_chart,
                            label: 'Enter Marks',
                            color: ColorConstants.primaryColor,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _buildActionButton(
                            icon: Icons.assignment,
                            label: 'Create Report',
                            color: ColorConstants.accentColor,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _buildActionButton(
                            icon: Icons.people,
                            label: 'Add Student',
                            color: ColorConstants.warningColor,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // CBC Subjects
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
                            'CBC Subjects',
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
                              'Junior Secondary',
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildSubjectChip(
                            'Mathematics',
                            ColorConstants.primaryColor,
                          ),
                          _buildSubjectChip(
                            'English',
                            ColorConstants.successColor,
                          ),
                          _buildSubjectChip(
                            'Kiswahili',
                            ColorConstants.accentColor,
                          ),
                          _buildSubjectChip(
                            'Integrated Science',
                            ColorConstants.warningColor,
                          ),
                          _buildSubjectChip(
                            'Social Studies',
                            ColorConstants.infoColor,
                          ),
                          _buildSubjectChip(
                            'Religious Education',
                            ColorConstants.errorColor,
                          ),
                          _buildSubjectChip(
                            'Health Education',
                            ColorConstants.successColor,
                          ),
                          _buildSubjectChip(
                            'Pre-Career Education',
                            ColorConstants.primaryColor,
                          ),
                          _buildSubjectChip(
                            'Business Studies',
                            ColorConstants.accentColor,
                          ),
                          _buildSubjectChip(
                            'Agriculture',
                            ColorConstants.warningColor,
                          ),
                          _buildSubjectChip(
                            'Life Skills',
                            ColorConstants.infoColor,
                          ),
                          _buildSubjectChip(
                            'Physical Education',
                            ColorConstants.errorColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View Curriculum',
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
                      _buildActivityItem(
                        icon: Icons.assignment,
                        title: 'End of Term Reports',
                        description: 'Created 12 reports for Class 8W',
                        time: '2 hours ago',
                        color: ColorConstants.successColor,
                      ),
                      const Divider(),
                      _buildActivityItem(
                        icon: Icons.grade,
                        title: 'Mathematics Marks',
                        description: 'Entered marks for Class 7E',
                        time: 'Yesterday',
                        color: ColorConstants.primaryColor,
                      ),
                      const Divider(),
                      _buildActivityItem(
                        icon: Icons.person_add,
                        title: 'New Student',
                        description: 'Added John Smith to Class 6W',
                        time: '2 days ago',
                        color: ColorConstants.warningColor,
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

              // Upcoming Events
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
                        'Upcoming Events',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildEventItem(
                        date: 'May 15',
                        title: 'End of Term Exams',
                        description: 'Final examinations for Term 2',
                        color: ColorConstants.errorColor,
                      ),
                      const SizedBox(height: 12),
                      _buildEventItem(
                        date: 'May 25',
                        title: 'Parent-Teacher Meeting',
                        description: 'Discussion of student progress',
                        color: ColorConstants.infoColor,
                      ),
                      const SizedBox(height: 12),
                      _buildEventItem(
                        date: 'Jun 5',
                        title: 'Report Card Distribution',
                        description: 'Handing out student report cards',
                        color: ColorConstants.successColor,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'View Calendar',
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
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
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
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String description,
    required String time,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
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
                Text(
                  description,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: ColorConstants.secondaryTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required String date,
    required String title,
    required String description,
    required Color color,
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
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
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
                Text(
                  description,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: ColorConstants.secondaryTextColor),
        ],
      ),
    );
  }

  Widget _buildSubjectChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: const Center(child: Text('Classes Page Content')),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text('Reports Page Content')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: const Center(child: Text('Profile Page Content')),
    );
  }
}
