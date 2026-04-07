import 'package:flutter/material.dart';
import 'hauler_notifications.dart';
import 'hauler_profile.dart';
import 'hauler_vas.dart';
import 'hauler_ecopoints.dart';

class HaulerHome extends StatefulWidget {
  const HaulerHome({super.key});

  @override
  State<HaulerHome> createState() => _HaulerHomeState();
}

class _HaulerHomeState extends State<HaulerHome> {
  int _selectedIndex = 0;
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB), // Light peach/nude background
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                children: [
                  // Verify Account Card
                  _buildActionCard(
                    icon: _isPending ? Icons.hourglass_empty : Icons.shield_outlined,
                    iconBgColor: _isPending ? const Color(0xFFFFF9C4) : const Color(0xFFDFF6DD),
                    iconColor: _isPending ? const Color(0xFFFBC02D) : const Color(0xFF4CAF50),
                    title: _isPending ? "Verification Pending..." : "Verify Your Account",
                    subtitle: _isPending 
                        ? "Your documents are currently under review" 
                        : "Complete verification to start hauling",
                    onTap: _isPending ? () {} : () async {
                      // We wait for the result from the VerifyAccountScreen
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VerifyAccountScreen()),
                      );

                      // If the result is true, update the state to Pending
                      if (result == true) {
                        setState(() {
                          _isPending = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // Eco-Points Card
                  _buildActionCard(
                    icon: Icons.star,
                    iconBgColor: const Color(0xFFDFF6DD),
                    iconColor: const Color(0xFFFFD700),
                    title: "How to Earn Eco-Points",
                    subtitle: "Learn how to collect and redeem points",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EcoPointsGuide()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Stats Row (Completed / Pending)
                  Row(
                    children: [
                      Expanded(child: _buildStatCard("0", "Completed", const Color(0xFF4CAF50))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard("0", "Pending", const Color(0xFFFFC107))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 1. Top Green Header
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

  // 2. Action Cards (Verify / Eco-Points)
  Widget _buildActionCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // 3. Status Stats Card
  Widget _buildStatCard(String count, String label, Color countColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: countColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // 4. Bottom Navigation matching the image icons
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Find Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined), label: 'My Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
        ],
      ),
    );
  }
}