import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/pages/dashboard/analytics/widgets/academic_performance_widget.dart';
import 'package:insighted/presentation/pages/dashboard/analytics/widgets/attendance_analytics_widget.dart';
import 'package:insighted/presentation/pages/dashboard/analytics/widgets/class_comparison_widget.dart';
import 'package:insighted/presentation/pages/dashboard/analytics/widgets/overview_widget.dart';
import 'package:insighted/presentation/pages/dashboard/analytics/widgets/teacher_performance_widget.dart';
import 'package:insighted/presentation/widgets/dashboard_app_bar.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _periods = [
    'This Term',
    'Past 6 Months',
    'Past Year',
    'All Time',
  ];
  String _selectedPeriod = 'This Term';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _fetchAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAnalyticsData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay - in a real app, this would fetch data from a repository
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changePeriod(String? period) {
    if (period != null && period != _selectedPeriod) {
      setState(() {
        _selectedPeriod = period;
      });
      _fetchAnalyticsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          // Period filter dropdown
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButton<String>(
              value: _selectedPeriod,
              icon: const Icon(Icons.arrow_drop_down),
              underline: Container(),
              items:
                  _periods.map((String period) {
                    return DropdownMenuItem<String>(
                      value: period,
                      child: Text(period),
                    );
                  }).toList(),
              onChanged: _changePeriod,
            ),
          ),
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              _showFilterDialog(context);
            },
          ),
          // Export button
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting analytics data...')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: ColorConstants.primaryColor,
          labelColor: ColorConstants.primaryColor,
          unselectedLabelColor: ColorConstants.secondaryTextColor,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Academic Performance'),
            Tab(text: 'Attendance'),
            Tab(text: 'Teacher Performance'),
            Tab(text: 'Class Comparison'),
          ],
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  OverviewWidget(period: _selectedPeriod),
                  AcademicPerformanceWidget(period: _selectedPeriod),
                  AttendanceAnalyticsWidget(period: _selectedPeriod),
                  TeacherPerformanceWidget(period: _selectedPeriod),
                  ClassComparisonWidget(period: _selectedPeriod),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorConstants.primaryColor,
        onPressed: () {
          // Generate report action
          _showReportOptionsDialog(context);
        },
        child: const Icon(Icons.analytics),
        tooltip: 'Generate Report',
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Analytics'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Classes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    _buildFilterChip('Grade 4', true),
                    _buildFilterChip('Grade 5', false),
                    _buildFilterChip('Grade 6', false),
                    _buildFilterChip('Grade 7', true),
                    _buildFilterChip('Grade 8', false),
                    _buildFilterChip('Grade 9', false),
                  ],
                ),

                const SizedBox(height: 16),
                const Text(
                  'Subjects',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    _buildFilterChip('Mathematics', true),
                    _buildFilterChip('English', true),
                    _buildFilterChip('Science', false),
                    _buildFilterChip('Social Studies', false),
                    _buildFilterChip('Kiswahili', false),
                  ],
                ),

                const SizedBox(height: 16),
                const Text(
                  'Teachers',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: [
                    _buildFilterChip('All Teachers', true),
                    _buildFilterChip('Class Teachers Only', false),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _fetchAnalyticsData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
              ),
              child: const Text('Apply Filters'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (bool selected) {
        // In a real app, this would update the filter state
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: ColorConstants.primaryColor.withOpacity(0.2),
      checkmarkColor: ColorConstants.primaryColor,
      labelStyle: TextStyle(
        color: selected ? ColorConstants.primaryColor : Colors.black87,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _showReportOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Generate Analytics Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildReportOption(
                'Performance Summary',
                'Overview of academic performance across all classes',
                Icons.pie_chart,
              ),
              _buildReportOption(
                'Attendance Report',
                'Detailed attendance statistics and trends',
                Icons.event_available,
              ),
              _buildReportOption(
                'Teacher Effectiveness',
                'Analysis of teacher performance metrics',
                Icons.person,
              ),
              _buildReportOption(
                'Custom Report',
                'Create a custom analytics report',
                Icons.build,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportOption(String title, String description, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: ColorConstants.primaryColor,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Generating $title report...')));
      },
    );
  }
}
