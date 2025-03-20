import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class AccountSettingsWidget extends StatelessWidget {
  const AccountSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSettingItem('Edit Profile', Icons.edit, () {
              // Navigate to profile edit page
            }),
            _buildSettingItem('Change Email', Icons.email, () {
              // Show email change dialog
            }),
            _buildSettingItem('Change Phone Number', Icons.phone, () {
              // Show phone change dialog
            }),
            _buildSettingItem('Update Profile Picture', Icons.camera_alt, () {
              // Show picture update dialog
            }, showDivider: false),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.primaryColor.withOpacity(0.1),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: 36,
              color: ColorConstants.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'School Administrator',
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 14,
                color: ColorConstants.secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: ColorConstants.primaryColor),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          contentPadding: EdgeInsets.zero,
          onTap: onTap,
        ),
        if (showDivider)
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
      ],
    );
  }
}
