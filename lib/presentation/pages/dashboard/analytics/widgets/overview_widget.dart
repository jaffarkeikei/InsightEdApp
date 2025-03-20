import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class OverviewWidget extends StatelessWidget {
  final String period;

  const OverviewWidget({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildPerformanceTrends(),
          const SizedBox(height: 24),
          _buildClassesOverview(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstants.primaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Summary of key metrics for $period',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildSummaryCard(
          title: 'Average Attendance',
          value: '87%',
          icon: Icons.event_available,
          color: ColorConstants.primaryColor,
          trend: '+2.3%',
          trendUp: true,
        ),
        _buildSummaryCard(
          title: 'Average Grade',
          value: 'B+',
          icon: Icons.grade,
          color: ColorConstants.accentColor,
          trend: '+0.5',
          trendUp: true,
        ),
        _buildSummaryCard(
          title: 'Teacher Performance',
          value: '92%',
          icon: Icons.person,
          color: ColorConstants.infoColor,
          trend: '+1.8%',
          trendUp: true,
        ),
        _buildSummaryCard(
          title: 'Class Engagement',
          value: '78%',
          icon: Icons.groups,
          color: ColorConstants.warningColor,
          trend: '-3.2%',
          trendUp: false,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool trendUp,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      trendUp
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      color: trendUp ? Colors.green : Colors.red,
                      size: 12,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Trends',
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
                  Icons.timeline,
                  size: 48,
                  color: ColorConstants.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Performance trends visualization',
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

  Widget _buildClassesOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Classes Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final classNames = ['Grade 4', 'Grade 7', 'Grade 9'];
            final performances = ['96%', '88%', '72%'];
            final colors = [
              ColorConstants.successColor,
              ColorConstants.infoColor,
              ColorConstants.warningColor,
            ];

            return _buildClassPerformanceItem(
              className: classNames[index],
              performance: performances[index],
              color: colors[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildClassPerformanceItem({
    required String className,
    required String performance,
    required Color color,
  }) {
    final double performanceValue =
        double.parse(performance.replaceAll('%', '')) / 100;

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Icon(Icons.school, color: color)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
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
                  'Overall Performance',
                  style: TextStyle(
                    fontSize: 12,
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
                performance,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 100,
                height: 6,
                child: LinearProgressIndicator(
                  value: performanceValue,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
