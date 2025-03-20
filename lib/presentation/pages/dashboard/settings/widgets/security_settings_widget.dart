import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class SecuritySettingsWidget extends StatefulWidget {
  const SecuritySettingsWidget({super.key});

  @override
  State<SecuritySettingsWidget> createState() => _SecuritySettingsWidgetState();
}

class _SecuritySettingsWidgetState extends State<SecuritySettingsWidget> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _rememberDevice = true;
  bool _dataSharing = false;

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
            _buildSwitchSetting(
              'Biometric Authentication',
              Icons.fingerprint,
              _biometricEnabled,
              (value) {
                setState(() {
                  _biometricEnabled = value;
                });
                if (value) {
                  _showEnableBiometricDialog();
                }
              },
            ),
            _buildSwitchSetting(
              'Two-Factor Authentication',
              Icons.security,
              _twoFactorEnabled,
              (value) {
                setState(() {
                  _twoFactorEnabled = value;
                });
                if (value) {
                  _showEnable2FADialog();
                }
              },
            ),
            _buildSwitchSetting(
              'Remember Devices',
              Icons.devices,
              _rememberDevice,
              (value) {
                setState(() {
                  _rememberDevice = value;
                });
              },
            ),
            _buildSwitchSetting('Data Sharing', Icons.share, _dataSharing, (
              value,
            ) {
              setState(() {
                _dataSharing = value;
              });
            }, showDivider: false),
            const SizedBox(height: 16),
            _buildActionSetting('Change Password', Icons.lock, () {
              _showChangePasswordDialog();
            }),
            _buildActionSetting(
              'Manage Authorized Devices',
              Icons.phone_android,
              () {
                // Navigate to authorized devices page
              },
            ),
            _buildActionSetting('View Data Privacy Policy', Icons.policy, () {
              // Navigate to data privacy policy page
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
    ValueChanged<bool> onChanged, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(title),
          secondary: Icon(icon, color: ColorConstants.successColor),
          value: value,
          onChanged: onChanged,
          activeColor: ColorConstants.successColor,
          contentPadding: EdgeInsets.zero,
        ),
        if (showDivider)
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
          leading: Icon(icon, color: ColorConstants.successColor),
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

  void _showEnableBiometricDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Biometric Login'),
          content: const Text(
            'This will allow you to log in using your fingerprint or face ID. Continue?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  _biometricEnabled = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Enable',
                style: TextStyle(color: ColorConstants.successColor),
              ),
              onPressed: () {
                // Biometric setup logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Biometric authentication enabled'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showEnable2FADialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enable Two-Factor Authentication'),
          content: const Text(
            'Two-factor authentication adds an extra layer of security to your account. We\'ll send a verification code to your phone whenever you sign in. Set up now?',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  _twoFactorEnabled = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Set Up',
                style: TextStyle(color: ColorConstants.successColor),
              ),
              onPressed: () {
                // 2FA setup logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Two-factor authentication enabled'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                  ),
                  obscureText: true,
                ),
              ],
            ),
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
                'Change Password',
                style: TextStyle(color: ColorConstants.successColor),
              ),
              onPressed: () {
                // Password change logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
