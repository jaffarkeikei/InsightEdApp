import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class SchoolSettingsWidget extends StatelessWidget {
  const SchoolSettingsWidget({super.key});

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
            _buildSchoolHeader(),
            const SizedBox(height: 20),
            _buildSettingItem('Edit School Information', Icons.edit_note, () {
              // Navigate to school edit page
            }),
            _buildSettingItem('Update School Logo', Icons.image, () {
              // Show logo update dialog
            }),
            _buildSettingItem('Manage School Branches', Icons.business, () {
              // Navigate to branches page
            }),
            _buildSettingItem(
              'Academic Calendar Settings',
              Icons.calendar_today,
              () {
                // Navigate to calendar settings
              },
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolHeader() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstants.accentColor.withOpacity(0.1),
          ),
          child: Center(
            child: Icon(
              Icons.school,
              size: 36,
              color: ColorConstants.accentColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Greenfield Primary School',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Nairobi, Kenya',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Est. 2005 • 450 Students',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
            ],
          ),
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
          leading: Icon(icon, color: ColorConstants.accentColor),
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
