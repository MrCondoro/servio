import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock data
final _mockNotifications = [
  const _NotificationItem(
    id: 'n1',
    title: 'New Order Received',
    message: 'Order #0042 from Table 3',
    timeAgo: '2 mins ago',
    isUnread: true,
  ),
  const _NotificationItem(
    id: 'n2',
    title: 'Low Stock Alert',
    message: 'Lettuce is below minimum threshold (2 kg).',
    timeAgo: '1 hour ago',
    isUnread: true,
  ),
  const _NotificationItem(
    id: 'n3',
    title: 'Shift Started',
    message: 'Welcome back! Your shift has started.',
    timeAgo: '4 hours ago',
    isUnread: false,
  ),
];

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isUnread,
  });
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Mark all as read
            },
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _mockNotifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = _mockNotifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            tileColor: notification.isUnread
                ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2)
                : null,
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    _getIconForTitle(notification.title),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                if (notification.isUnread)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(notification.message),
                const SizedBox(height: 4),
                Text(
                  notification.timeAgo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            onTap: () {
              // TODO: Navigate or mark as read
            },
          );
        },
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    if (title.contains('Order')) return Icons.receipt_long;
    if (title.contains('Stock')) return Icons.warning_amber_rounded;
    return Icons.info_outline;
  }
}
