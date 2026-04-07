import 'package:flutter/material.dart';
import 'hauler_notifications.dart';
import 'hauler_profile.dart';
import 'hauler_mainecopoints.dart';

class HaulerMainHome extends StatefulWidget {
  const HaulerMainHome({super.key});

  @override
  State<HaulerMainHome> createState() => _HaulerMainHomeState();
}

class _HaulerMainHomeState extends State<HaulerMainHome> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB), // Light peach background
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                      children: [
                        _buildVerifiedStatusCard(),
                        const SizedBox(height: 10),
                        _buildEcoPointsCard(),
                        const SizedBox(height: 10),
                        _buildStatsRow(),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  _buildOngoingJobsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 1. Top Header (Consistent with your previous style)
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 40),
      decoration: const BoxDecoration(
        color: Color(0xFFDFF6DD), // Light green header
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Waste2Wage',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hi Juan Dela Cruz!',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HaulerNotifications()),
                  );
                },
                child: _buildHeaderIcon(Icons.notifications_none),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HaulerProfile()),
                  );
                },
                icon: const Icon(Icons.person_outline, color: Colors.green, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(8),
                ),
              ),            
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.green, size: 28),
    );
  }

  // 2. Verified Gradient Card
  Widget _buildVerifiedStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF26BB86), Color(0xFF1E9B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.directions_bike, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text("Cyclist Hauler", 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(Icons.check, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text("Verified", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          const Text("0 / 10", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
          const Text("Jobs Today", style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  // 3. Eco-Points Card
  Widget _buildEcoPointsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFDFF6DD), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.star, color: Color(0xFFFFD700), size: 30),
        ),
        title: const Text("View Eco-Points", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: const Text("Track your earnings and history"),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EcoPointsMainScreen())),
      ),
    );
  }

  // 4. Stats Row
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard("0", "Completed", const Color(0xFF34A853))),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard("0", "Pending", const Color(0xFFFBC02D))),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // 5. Ongoing Jobs Section
  Widget _buildOngoingJobsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFEBE6E3), // Slightly darker background for the bottom section
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ongoing Jobs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          _buildJobItem("Maria Santos", "Liberty St., Brgy Sauyo", "Mon, Feb 10 - 9:00 AM", "₱60", Colors.blue),
          _buildJobItem("Maria Santos", "Liberty St., Brgy Sauyo", "Mon, Feb 10 - 9:00 AM", "₱60", Colors.yellow),
          _buildJobItem("Maria Santos", "Liberty St., Brgy Sauyo", "Mon, Feb 10 - 9:00 AM", "₱60", Colors.green),
        ],
      ),
    );
  }

  Widget _buildJobItem(String name, String address, String time, String price, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: iconColor, child: const Icon(Icons.delete, color: Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                child: const Text("Ongoing", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              Text(price, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined), label: 'My Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
      ],
    );
  }
}