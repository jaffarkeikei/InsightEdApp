import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/pages/dashboard/settings/settings_page.dart';
import 'package:insighted/presentation/pages/auth/login_page.dart';

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/default_avatar.png'),
          onBackgroundImageError: null,
          child: Icon(Icons.person, color: Colors.grey),
        ),
      ),
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'profile_header',
              enabled: false,
              child: _buildProfileHeader(),
            ),
            const PopupMenuDivider(),
            _buildPopupMenuItem(
              value: 'my_profile',
              icon: Icons.person_outline,
              text: 'My Profile',
            ),
            _buildPopupMenuItem(
              value: 'account_settings',
              icon: Icons.settings_outlined,
              text: 'Account Settings',
            ),
            _buildPopupMenuItem(
              value: 'help',
              icon: Icons.help_outline,
              text: 'Help & Support',
            ),
            const PopupMenuDivider(),
            _buildPopupMenuItem(
              value: 'logout',
              icon: Icons.logout,
              text: 'Log Out',
              color: ColorConstants.errorColor,
            ),
          ],
      onSelected: (String value) {
        _handleMenuItemSelected(context, value);
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color ?? ColorConstants.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: color ?? Colors.black87,
              fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/images/default_avatar.png'),
              onBackgroundImageError: null,
              child: Icon(Icons.person, color: Colors.grey, size: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'John Doe',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'School Administrator',
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
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.mail_outline,
                color: ColorConstants.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: ColorConstants.primaryTextColor,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'my_profile':
        // Navigate to profile page
        break;
      case 'account_settings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      case 'help':
        // Navigate to help page
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
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
