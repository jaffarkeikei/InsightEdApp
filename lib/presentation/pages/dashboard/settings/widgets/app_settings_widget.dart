import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class AppSettingsWidget extends StatefulWidget {
  const AppSettingsWidget({super.key});

  @override
  State<AppSettingsWidget> createState() => _AppSettingsWidgetState();
}

class _AppSettingsWidgetState extends State<AppSettingsWidget> {
  bool _darkMode = false;
  bool _highContrastMode = false;
  bool _largeFontSize = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Kiswahili', 'French', 'Arabic'];

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
            _buildSwitchSetting('Dark Mode', Icons.dark_mode, _darkMode, (
              value,
            ) {
              setState(() {
                _darkMode = value;
              });
              // Apply theme change logic
            }),
            _buildSwitchSetting(
              'High Contrast Mode',
              Icons.contrast,
              _highContrastMode,
              (value) {
                setState(() {
                  _highContrastMode = value;
                });
                // Apply high contrast mode logic
              },
            ),
            _buildSwitchSetting(
              'Large Font Size',
              Icons.format_size,
              _largeFontSize,
              (value) {
                setState(() {
                  _largeFontSize = value;
                });
                // Apply font size change logic
              },
            ),
            _buildDropdownSetting(
              'Language',
              Icons.language,
              _selectedLanguage,
              _languages,
              (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  // Apply language change logic
                }
              },
            ),
            _buildActionSetting('Clear Cache', Icons.cleaning_services, () {
              // Show dialog and clear cache
              _showClearCacheDialog();
            }, showDivider: false),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(title),
          secondary: Icon(icon, color: ColorConstants.infoColor),
          value: value,
          onChanged: onChanged,
          activeColor: ColorConstants.infoColor,
          contentPadding: EdgeInsets.zero,
        ),
        Divider(color: Colors.grey.withOpacity(0.2), height: 1),
      ],
    );
  }

  Widget _buildDropdownSetting(
    String title,
    IconData icon,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: ColorConstants.infoColor),
              const SizedBox(width: 16),
              Text(title),
              const Spacer(),
              DropdownButton<String>(
                value: value,
                items:
                    items.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                onChanged: onChanged,
                underline: Container(),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.withOpacity(0.2), height: 1),
      ],
    );
  }

  Widget _buildActionSetting(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: ColorConstants.infoColor),
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

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all cached data. The app may take longer to load next time. Are you sure?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Clear',
                style: TextStyle(color: ColorConstants.errorColor),
              ),
              onPressed: () {
                // Clear cache logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
