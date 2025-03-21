import 'package:flutter/material.dart';
// import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/core/constants/color_constants.dart';
import 'package:insighted/presentation/pages/dashboard/widgets/profile_dropdown.dart';
import 'package:insighted/presentation/pages/dashboard/widgets/notifications_panel.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;

  const DashboardAppBar({
    super.key,
    required this.title,
    this.additionalActions,
    this.showBackButton = false,
    this.onBackPressed,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: ColorConstants.primaryColor,
      foregroundColor: Colors.white,
      elevation: 1,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
              : null,
      actions: [
        ...(additionalActions ?? []),
        const SizedBox(width: 8),
        // Notifications Button
        const NotificationsPanel(),
        const SizedBox(width: 8),
        // Profile Button
        const ProfileDropdown(),
        const SizedBox(width: 8),
      ],
    );
  }
}
