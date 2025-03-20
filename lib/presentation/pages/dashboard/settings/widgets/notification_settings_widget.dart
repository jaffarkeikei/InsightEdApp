import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _announcementNotifications = true;
  bool _gradeNotifications = true;
  bool _attendanceNotifications = true;
  bool _calendarNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Notification Channels',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.warningColor,
                ),
              ),
            ),
            _buildSwitchSetting(
              'Email Notifications',
              Icons.email,
              _emailNotifications,
              (value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            _buildSwitchSetting(
              'Push Notifications',
              Icons.notifications,
              _pushNotifications,
              (value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Notification Types',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.warningColor,
                ),
              ),
            ),
            _buildSwitchSetting(
              'Announcements',
              Icons.campaign,
              _announcementNotifications,
              (value) {
                setState(() {
                  _announcementNotifications = value;
                });
              },
            ),
            _buildSwitchSetting(
              'Grades & Assessments',
              Icons.grade,
              _gradeNotifications,
              (value) {
                setState(() {
                  _gradeNotifications = value;
                });
              },
            ),
            _buildSwitchSetting(
              'Attendance',
              Icons.fact_check,
              _attendanceNotifications,
              (value) {
                setState(() {
                  _attendanceNotifications = value;
                });
              },
            ),
            _buildSwitchSetting(
              'Calendar Events',
              Icons.event_note,
              _calendarNotifications,
              (value) {
                setState(() {
                  _calendarNotifications = value;
                });
              },
              showDivider: false,
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              'Manage Notification Schedule',
              Icons.schedule,
              () {
                // Navigate to notification schedule page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(title),
          secondary: Icon(icon, color: ColorConstants.warningColor),
          value: value,
          onChanged: onChanged,
          activeColor: ColorConstants.warningColor,
          contentPadding: EdgeInsets.zero,
        ),
        if (showDivider)
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: ColorConstants.warningColor, size: 18),
      label: Text(title, style: TextStyle(color: ColorConstants.warningColor)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: ColorConstants.warningColor.withOpacity(0.5)),
        ),
        backgroundColor: ColorConstants.warningColor.withOpacity(0.05),
      ),
    );
  }
}
