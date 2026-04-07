import 'package:flutter/material.dart';
import 'resident_rewards.dart';
import 'resident_notifications.dart';
import 'resident_schedule_pickup.dart';
import 'resident_bookings.dart'; // Import Bookings Screen
import 'resident_profile.dart'; // Import Profile Screen
import 'resident_wallet.dart'; 
import 'resident_trackhauler.dart';

class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  int _selectedIndex = 0; // Tracks which tab is active

  // --- 1. DEFINE THE SCREENS HERE ---
  final List<Widget> _screens = [
    const ResidentHomeContent(),    // Home Content (Defined below)
    const ResidentBookingsScreen(), // Bookings Screen
    const WalletScreen(), // Placeholder
    const ResidentProfileScreen(), // Profile Screen
  ];

  @override
  Widget build(BuildContext context) {
    // --- PALETTE ---
    final Color textGreen = const Color(0xFF388E3C);

    return Scaffold(
      // --- 2. SWITCH BODY BASED ON INDEX ---
      body: _screens[_selectedIndex],

      // --- 3. NAVIGATION BAR ---
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: textGreen, 
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white);
            }
            return IconThemeData(color: Colors.grey[600]);
          }),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: Colors.white,
          elevation: 10,
          shadowColor: Colors.black.withValues(alpha: 0.1),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. YOUR COMPACT HOME DESIGN ---
class ResidentHomeContent extends StatelessWidget {
  const ResidentHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALETTE ---
    final Color bgCream = const Color(0xFFFFF8F3);
    final Color centerGlowGreen = const Color(0xFFF1FBEB);
    final Color headerGreen = const Color(0xFFDFF6DD);
    final Color textGreen = const Color(0xFF388E3C);
    final Color brandTeal = const Color(0xFF1EBE71);

    return Container(
      decoration: BoxDecoration(
        // Gradient Background
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.3,
          colors: [
            centerGlowGreen,
            bgCream,
          ],
          stops: const [0.1, 1.0],
        ),
      ),
      child: Column(
        children: [
          // 1. COMPACT HEADER
          Container(
            // [FIXED] Reduced padding to make it smaller
            padding: const EdgeInsets.only(top: 45, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: headerGreen,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Waste2Wage",
                      style: TextStyle(
                        color: textGreen,
                        fontSize: 22, // Slightly smaller font
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Hi Maria!",
                      style: TextStyle(
                        color: textGreen.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ResidentNotificationsScreen()),
                    );
                  },
                  icon: Icon(Icons.notifications_outlined,
                      color: textGreen, size: 26),
                ),
              ],
            ),
          ),

          // 2. SCROLLABLE CONTENT
          Expanded(
            child: ListView(
              // [FIXED] Reduced top padding (from 25 to 15) to remove the gap
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // A. SCHEDULE PICKUP BUTTON
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ResidentSchedulePickupScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    shadowColor: brandTeal.withValues(alpha: 0.4),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, size: 28),
                      SizedBox(width: 10),
                      Text(
                        "Schedule Pickup",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // B. VIEW ECO-POINTS BUTTON
                Container(
                  decoration: BoxDecoration(
                    color: brandTeal,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: brandTeal.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResidentRewardsScreen()),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF176), // Yellow
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star,
                                  color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 15),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "View Eco-Points",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Track your earnings & history",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // C. PROGRESS CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "3/6 Completed Segregated Pickups",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Complete 6 Segregated Pickups for 1 Free Pickup",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 15),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 3 / 6,
                          minHeight: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(textGreen),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // 3. TRACK HAULER BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ResidentTrackHaulerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      shadowColor: brandTeal.withValues(alpha: 0.4),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Track Hauler",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}