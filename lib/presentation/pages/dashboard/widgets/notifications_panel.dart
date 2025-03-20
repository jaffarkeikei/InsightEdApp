import 'package:flutter/material.dart';
import 'package:insighted/core/constants/color_constants.dart';

class NotificationsPanel extends StatefulWidget {
  const NotificationsPanel({super.key});

  @override
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _unreadCount = 3;

  final List<NotificationItem> _allNotifications = [
    NotificationItem(
      title: 'New student enrollment',
      message: 'Mary Wanjiku has been enrolled in Grade 5A',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
      type: NotificationType.student,
      isRead: false,
    ),
    NotificationItem(
      title: 'Exam results published',
      message: 'Term 2 exam results for Grade 6 have been published',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.academic,
      isRead: false,
    ),
    NotificationItem(
      title: 'System update',
      message: 'InsightEd has been updated to version 1.2.0',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.system,
      isRead: false,
    ),
    NotificationItem(
      title: 'New teacher assigned',
      message:
          'Mr. James Kamau has been assigned to teach Mathematics for Grade 7',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.staff,
      isRead: true,
    ),
    NotificationItem(
      title: 'Attendance report',
      message: 'Monthly attendance report for April is now available',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.attendance,
      isRead: true,
    ),
    NotificationItem(
      title: 'Parent meeting reminder',
      message: 'Parent-teacher meeting scheduled for next Monday, 3:00 PM',
      time: DateTime.now().subtract(const Duration(days: 3)),
      type: NotificationType.event,
      isRead: true,
    ),
  ];

  List<NotificationItem> get _unreadNotifications =>
      _allNotifications.where((notification) => !notification.isRead).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            _showNotificationsPanel(context);
          },
        ),
        if (_unreadCount > 0)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: ColorConstants.errorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  _unreadCount <= 9 ? '$_unreadCount' : '9+',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showNotificationsPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          color: ColorConstants.primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_unreadCount > 0)
                        TextButton(
                          onPressed: _markAllAsRead,
                          child: Text(
                            'Mark All as Read',
                            style: TextStyle(
                              color: ColorConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: ColorConstants.primaryColor,
                  unselectedLabelColor: ColorConstants.secondaryTextColor,
                  indicatorColor: ColorConstants.primaryColor,
                  tabs: [
                    Tab(text: 'All (${_allNotifications.length})'),
                    Tab(text: 'Unread ($_unreadCount)'),
                  ],
                ),
                // List
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // All notifications
                      _buildNotificationsList(
                        _allNotifications,
                        scrollController,
                      ),
                      // Unread notifications
                      _buildNotificationsList(
                        _unreadNotifications,
                        scrollController,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNotificationsList(
    List<NotificationItem> notifications,
    ScrollController scrollController,
  ) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                color: ColorConstants.secondaryTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notifications.length,
      separatorBuilder:
          (context, index) => Divider(color: Colors.grey.shade200, height: 1),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.title),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: ColorConstants.errorColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _allNotifications.remove(notification);
          if (!notification.isRead) {
            _unreadCount--;
          }
        });
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getNotificationColor(
            notification.type,
          ).withOpacity(0.1),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                color: ColorConstants.secondaryTextColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _formatTime(notification.time),
              style: TextStyle(
                color: ColorConstants.secondaryTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing:
            notification.isRead
                ? null
                : Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: ColorConstants.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
        onTap: () {
          _markAsRead(notification);
          // In a real app, this would navigate to the appropriate page
          Navigator.pop(context);
        },
      ),
    );
  }

  void _markAsRead(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
        _unreadCount--;
      });
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification.isRead = true;
      }
      _unreadCount = 0;
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.student:
        return Icons.person;
      case NotificationType.staff:
        return Icons.person_2;
      case NotificationType.academic:
        return Icons.school;
      case NotificationType.attendance:
        return Icons.check_circle;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.system:
        return Icons.system_update;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.student:
        return ColorConstants.primaryColor;
      case NotificationType.staff:
        return ColorConstants.accentColor;
      case NotificationType.academic:
        return ColorConstants.infoColor;
      case NotificationType.attendance:
        return ColorConstants.successColor;
      case NotificationType.event:
        return ColorConstants.warningColor;
      case NotificationType.system:
        return ColorConstants.errorColor;
    }
  }
}

enum NotificationType { student, staff, academic, attendance, event, system }

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}
