import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class ParentDashboardPage extends StatefulWidget {
  const ParentDashboardPage({super.key});

  @override
  State<ParentDashboardPage> createState() => _ParentDashboardPageState();
}

class _ParentDashboardPageState extends State<ParentDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ParentHomePage(),
    const ChildrenPage(),
    const ParentReportsPage(),
    const ParentProfilePage(),
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
            icon: Icon(Icons.child_care_outlined),
            activeIcon: Icon(Icons.child_care),
            label: 'Children',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            activeIcon: Icon(Icons.assessment),
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

class ParentHomePage extends StatelessWidget {
  const ParentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
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
                'Welcome back, Parent!',
                style: TextStyle(
                  color: ColorConstants.primaryTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your children\'s educational journey',
                style: TextStyle(
                  color: ColorConstants.secondaryTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Children Overview
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
                        'Your Children',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChildCard(
                        name: 'David Johnson',
                        grade: 'Grade 6',
                        imageUrl: null,
                        performance: 'Excellent',
                        attendanceRate: 98,
                        color: ColorConstants.successColor,
                      ),
                      const SizedBox(height: 12),
                      _buildChildCard(
                        name: 'Emma Johnson',
                        grade: 'Grade 9',
                        imageUrl: null,
                        performance: 'Good',
                        attendanceRate: 95,
                        color: ColorConstants.infoColor,
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

              // CBC Subject Performance
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
                            'David\'s Subject Performance',
                            style: TextStyle(
                              color: ColorConstants.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: 'Term 2',
                            items:
                                ['Term 1', 'Term 2', 'Term 3'].map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: ColorConstants.primaryColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (_) {},
                            underline: const SizedBox(),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildSubjectPerformance(
                              subject: 'Mathematics',
                              score: 85,
                              color: ColorConstants.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            _buildSubjectPerformance(
                              subject: 'English',
                              score: 76,
                              color: ColorConstants.infoColor,
                            ),
                            const SizedBox(width: 12),
                            _buildSubjectPerformance(
                              subject: 'Science',
                              score: 92,
                              color: ColorConstants.successColor,
                            ),
                            const SizedBox(width: 12),
                            _buildSubjectPerformance(
                              subject: 'Social Studies',
                              score: 78,
                              color: ColorConstants.warningColor,
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

              // Upcoming Events and Parent-Teacher Communication
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      title: 'Upcoming Events',
                      content: [
                        'Parent-Teacher Meeting - May 20',
                        'School Sports Day - Jun 5',
                        'End of Term Exams - Jul 15',
                      ],
                      icon: Icons.event,
                      color: ColorConstants.accentColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      title: 'Messages',
                      content: [
                        'Mr. Smith: Math homework reminder',
                        'Ms. Johnson: Science project update',
                        'Principal: School newsletter',
                      ],
                      icon: Icons.message,
                      color: ColorConstants.infoColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Fee Payment Status
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
                        'Fee Payment Status',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildFeeStatus(
                            child: 'David Johnson',
                            term: 'Term 2',
                            amount: 'Ksh 15,000',
                            status: 'Paid',
                            color: ColorConstants.successColor,
                          ),
                          const SizedBox(width: 16),
                          _buildFeeStatus(
                            child: 'Emma Johnson',
                            term: 'Term 2',
                            amount: 'Ksh 18,000',
                            status: 'Due (Jun 30)',
                            color: ColorConstants.warningColor,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Payment History',
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
        child: const Icon(Icons.message),
        onPressed: () {},
      ),
    );
  }

  Widget _buildChildCard({
    required String name,
    required String grade,
    required String? imageUrl,
    required String performance,
    required int attendanceRate,
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
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
            child:
                imageUrl == null
                    ? Text(
                      name.substring(0, 1),
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  grade,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      performance,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today,
                      color: ColorConstants.secondaryTextColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$attendanceRate% Attendance',
                      style: TextStyle(
                        color: ColorConstants.secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
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

  Widget _buildSubjectPerformance({
    required String subject,
    required int score,
    required Color color,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
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
                      value: score / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$score%',
                    style: TextStyle(
                      color: color,
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
            subject,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstants.primaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _getGradeFromScore(score),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getGradeFromScore(int score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C+';
    if (score >= 50) return 'C';
    if (score >= 40) return 'D+';
    if (score >= 30) return 'D';
    return 'E';
  }

  Widget _buildInfoCard({
    required String title,
    required List<String> content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...content.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  item,
                  style: TextStyle(
                    color: ColorConstants.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeStatus({
    required String child,
    required String term,
    required String amount,
    required String status,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              child,
              style: TextStyle(
                color: ColorConstants.primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              term,
              style: TextStyle(
                color: ColorConstants.secondaryTextColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                color: ColorConstants.primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChildrenPage extends StatelessWidget {
  const ChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Children'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: const Center(child: Text('Children Page Content')),
    );
  }
}

class ParentReportsPage extends StatelessWidget {
  const ParentReportsPage({super.key});

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

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({super.key});

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
