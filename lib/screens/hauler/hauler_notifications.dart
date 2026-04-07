import 'package:flutter/material.dart';

class HaulerNotifications extends StatelessWidget {
  const HaulerNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB), // Light peach background
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Mark all read button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.done_all, size: 18, color: Color(0xFF2E7D32)),
                      label: const Text(
                        "Mark all read",
                        style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFDFF6DD),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notification List
                  _buildNotificationTile(
                    title: "Payment Received",
                    subtitle: "₱60 has been added to your wallet",
                    time: "Just now",
                    icon: Icons.check,
                    iconBgColor: const Color(0xFFA5D6A7),
                    iconColor: Colors.green.shade800,
                    isUnread: true,
                  ),
                  _buildNotificationTile(
                    title: "New Job Available",
                    subtitle: "A new pickup request near your area!",
                    time: "2 mins ago",
                    icon: Icons.priority_high,
                    iconBgColor: const Color(0xFF9FA8DA),
                    iconColor: Colors.blue.shade900,
                    isUnread: true,
                  ),
                  _buildNotificationTile(
                    title: "Eco-Points Earned!",
                    subtitle: "You earned 15 eco-points today!",
                    time: "3 hours ago",
                    icon: Icons.card_giftcard,
                    iconBgColor: const Color(0xFFFFF59D),
                    iconColor: Colors.orange.shade800,
                    isUnread: false,
                  ),
                  _buildNotificationTile(
                    title: "Remider", // Matching the typo in your image "Remider"
                    subtitle: "You have a scheduled pickup tomorrow at 8 AM",
                    time: "5 hours ago",
                    icon: Icons.check,
                    iconBgColor: const Color(0xFFA5D6A7),
                    iconColor: Colors.green.shade800,
                    isUnread: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Header with back button
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFDFF6DD),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32), size: 30),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          ),
          const SizedBox(width: 8),
          const Text(
            'Notifications',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  // Flexible Notification Tile
  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), // Subtle transparent white
        borderRadius: BorderRadius.circular(15),
        // Green border only if unread
        border: Border.all(
          color: isUnread ? Colors.green.shade400 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: iconBgColor,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          if (isUnread)
            const Positioned(
              right: 15,
              top: 15,
              child: CircleAvatar(
                radius: 4,
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}