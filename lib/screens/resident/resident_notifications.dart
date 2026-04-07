import 'package:flutter/material.dart';

class ResidentNotificationsScreen extends StatefulWidget {
  const ResidentNotificationsScreen({super.key});

  @override
  State<ResidentNotificationsScreen> createState() => _ResidentNotificationsScreenState();
}

class _ResidentNotificationsScreenState extends State<ResidentNotificationsScreen> {
  // --- COLORS ---
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);
  
  // Specific Button Color from image
  final Color buttonLightGreen = const Color(0xFFC8E6C9); 

  // --- DUMMY DATA ---
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "title": "Pickup Confirmed",
      "body": "Your waste pickup for Feb 13 has been confirmed.",
      "time": "about 3 hours ago",
      "type": "success", // Green Check
      "isRead": false,
    },
    {
      "id": 2,
      "title": "New Reward Available",
      "body": "Redeem your Eco-Points",
      "time": "Just now",
      "type": "alert", // Purple Exclamation
      "isRead": false,
    },
    {
      "id": 3,
      "title": "Eco-Points Earned!",
      "body": "You earned 20 Eco-Points for your segregated waste pickup.",
      "time": "Yesterday",
      "type": "reward", // Yellow Gift
      "isRead": true,
    },
    {
      "id": 4,
      "title": "Pickup Completed!",
      "body": "Your waste pickup has been completed successfully.",
      "time": "3 days ago",
      "type": "success",
      "isRead": true,
    },
  ];

  // --- LOGIC ---
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("All notifications marked as read"),
        backgroundColor: textGreen,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markSingleAsRead(int index) {
    if (!_notifications[index]['isRead']) {
      setState(() {
        _notifications[index]['isRead'] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if there are unread items to show/hide the button if needed
    // (Or keep it always visible based on your preference. Image shows it visible)
    bool hasUnread = _notifications.any((n) => n['isRead'] == false);

    return Scaffold(
      backgroundColor: bgCream,
      
      body: Column(
        children: [
          // 1. COMPACT HEADER
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: headerGreen,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textGreen,
                  ),
                ),
              ],
            ),
          ),

          // 2. MARK ALL READ BUTTON (Aligned Right)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, right: 20),
              child: ElevatedButton.icon(
                onPressed: hasUnread ? _markAllAsRead : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonLightGreen, // Light Green background
                  foregroundColor: textGreen, // Dark Green Text
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.done_all, size: 18),
                label: const Text(
                  "Mark all read",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),

          // 3. NOTIFICATION LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return _buildNotificationCard(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item, int index) {
    bool isRead = item['isRead'];

    return GestureDetector(
      onTap: () => _markSingleAsRead(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          // Unread: Slightly darker background. Read: Transparent/White
          color: isRead ? Colors.transparent : const Color(0xFFF1F8E9), 
          borderRadius: BorderRadius.circular(15),
          // Unread: Green Border. Read: No Border.
          border: isRead 
            ? null 
            : Border.all(color: textGreen, width: 1),
          // Subtle shadow only if read (to make it look like part of the list), 
          // or unread can have shadow too.
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON
            _buildIcon(item['type']),
            
            const SizedBox(width: 15),
            
            // CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      // Green Dot if Unread
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: textGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['body'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['time'],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the specific colored circular icons
  Widget _buildIcon(String type) {
    Color bgColor;
    Color iconColor;
    IconData iconData;

    switch (type) {
      case 'alert':
        bgColor = const Color(0xFFE0E7FF); // Light Purple/Blue
        iconColor = const Color(0xFF4F46E5);
        iconData = Icons.priority_high;
        break;
      case 'reward':
        bgColor = const Color(0xFFFFF9C4); // Light Yellow
        iconColor = const Color(0xFFFBC02D);
        iconData = Icons.card_giftcard;
        break;
      case 'success':
      default:
        bgColor = const Color(0xFFC8E6C9); // Light Green
        iconColor = textGreen;
        iconData = Icons.check_circle_outline;
        break;
    }

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }
}