import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/pages/dashboard/settings/widgets/account_settings_widget.dart';
import 'package:insighted/presentation/pages/dashboard/settings/widgets/app_settings_widget.dart';
import 'package:insighted/presentation/pages/dashboard/settings/widgets/notification_settings_widget.dart';
import 'package:insighted/presentation/pages/dashboard/settings/widgets/security_settings_widget.dart';
import 'package:insighted/presentation/pages/dashboard/settings/widgets/school_settings_widget.dart';
import 'package:insighted/presentation/pages/auth/login_page.dart';
import 'package:insighted/presentation/widgets/dashboard_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Account Settings'),
          const SizedBox(height: 8),
          const AccountSettingsWidget(),

          const SizedBox(height: 24),
          _buildSectionHeader('School Profile'),
          const SizedBox(height: 8),
          const SchoolSettingsWidget(),

          const SizedBox(height: 24),
          _buildSectionHeader('App Settings'),
          const SizedBox(height: 8),
          const AppSettingsWidget(),

          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          const SizedBox(height: 8),
          const NotificationSettingsWidget(),

          const SizedBox(height: 24),
          _buildSectionHeader('Security & Privacy'),
          const SizedBox(height: 8),
          const SecuritySettingsWidget(),

          const SizedBox(height: 24),
          _buildLogoutButton(context),

          const SizedBox(height: 24),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorConstants.primaryColor,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstants.errorColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'InsightEd',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              color: ColorConstants.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAboutButton(
                'Privacy Policy',
                Icons.privacy_tip_outlined,
                () {},
              ),
              const SizedBox(width: 24),
              _buildAboutButton(
                'Terms of Service',
                Icons.description_outlined,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: ColorConstants.primaryColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: ColorConstants.primaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out of InsightEd?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Log Out',
                style: TextStyle(color: ColorConstants.errorColor),
              ),
              onPressed: () {
                // Clear user session/tokens here
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
