import 'package:flutter/material.dart';

class ResidentRewardsScreen extends StatefulWidget {
  const ResidentRewardsScreen({super.key});

  @override
  State<ResidentRewardsScreen> createState() => _ResidentRewardsScreenState();
}

class _ResidentRewardsScreenState extends State<ResidentRewardsScreen> {
  // Toggle State: 0 = Rewards, 1 = History
  int _selectedTab = 0; 

  @override
  Widget build(BuildContext context) {
    // --- PALETTE ---
    final Color bgCream = const Color(0xFFFFF8F3);
    final Color headerGreen = const Color(0xFFDFF6DD); 
    final Color textGreen = const Color(0xFF388E3C);
    final Color cardGreenStart = const Color(0xFF2ECC71);
    final Color cardGreenEnd = const Color(0xFF1EBE71);

    return Scaffold(
      backgroundColor: bgCream,
      
      // --- BODY ---
      body: Column(
        children: [
          // 1. COMPACT HEADER (Adjusted Padding)
          Container(
            // [FIXED] Reduced padding to make the green background smaller
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
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
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero, // Removes extra default padding
                  constraints: const BoxConstraints(), // Tightens the icon area
                ),
                const SizedBox(width: 15),
                Text(
                  "My Reward Points",
                  style: TextStyle(
                    color: textGreen,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 2. SCROLLABLE CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(25),
              physics: const BouncingScrollPhysics(),
              children: [
                
                // A. BALANCE CARD
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cardGreenStart, cardGreenEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cardGreenEnd.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Title + Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Eco-Points Balance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.eco_outlined, color: Colors.white, size: 40),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Big Balance Text
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "100",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "EP",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),

                      // Bottom Stats (Earned / Redeemed)
                      Row(
                        children: [
                          _buildStatItem(Icons.arrow_downward, "Earned", "+20 EP"),
                          const Spacer(),
                          _buildStatItem(Icons.arrow_upward, "Redeemed", "-20 EP"),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // B. TAB SWITCHER (Rewards / History)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton("Rewards", 0),
                      _buildTabButton("History", 1),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // C. LIST CONTENT (SWITCHES BASED ON TAB)
                if (_selectedTab == 0) ...[
                  // --- REWARDS TAB ---
                  _buildRewardItem(
                    title: "Standard Booking",
                    subtitle: "Complete 1 Waste Pickup",
                    points: "+10 EP",
                    isRedeemed: true, 
                  ),
                  _buildRewardItem(
                    title: "Segregated Booking",
                    subtitle: "Complete 1 Segregated Pickup",
                    points: "+15 EP",
                    isRedeemed: false,
                  ),
                  _buildRewardItem(
                    title: "Free Pickup Milestone",
                    subtitle: "Completed 7 Segregated Pickup",
                    points: "+100 EP",
                    isRedeemed: false,
                  ),
                  _buildRewardItem(
                    title: "Streak Bonus",
                    subtitle: "Completed 4-Week Booking Streak",
                    points: "+50 EP",
                    isRedeemed: false,
                  ),
                  _buildRewardItem(
                    title: "Referral Reward",
                    subtitle: "1 Successful Referral Completed",
                    points: "+20 EP",
                    isRedeemed: false,
                  ),
                ] else ...[
                  // --- HISTORY TAB ---
                  _buildHistoryItem(
                    title: "Standard Booking",
                    date: "Today",
                    points: "+10 EP",
                  ),
                  _buildHistoryItem(
                    title: "Segregated Booking",
                    date: "Yesterday",
                    points: "+15 EP",
                  ),
                  _buildHistoryItem(
                    title: "Streak Bonus",
                    date: "Feb 9",
                    points: "+50 EP",
                    isHighlighted: false, 
                  ),
                  _buildHistoryItem(
                    title: "Scheduled Pickup",
                    date: "Feb 9",
                    points: "-100 EP", // Negative (Red)
                  ),
                  _buildHistoryItem(
                    title: "Referral Reward",
                    date: "Feb 9",
                    points: "+20 EP",
                  ),
                ],
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---

  // 1. Stats Helper 
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // 2. Tab Button Helper
  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // 3. Reward Item Helper
  Widget _buildRewardItem({
    required String title,
    required String subtitle,
    required String points,
    required bool isRedeemed,
  }) {
    final Color textGreen = const Color(0xFF388E3C);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9), 
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: textGreen.withValues(alpha: 0.3)),
                ),
                child: Text(points, style: TextStyle(color: textGreen, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: isRedeemed ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textGreen,
                    disabledBackgroundColor: const Color(0xFFC8E6C9),
                    disabledForegroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: isRedeemed ? 0 : 2,
                  ),
                  child: Text(
                    isRedeemed ? "Redeemed" : "Redeem",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. History Item Helper
  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String points,
    bool isHighlighted = false, 
  }) {
    // Check if points are positive (+) or negative (-)
    final bool isPositive = points.startsWith('+');
    final Color pointsColor = isPositive ? const Color(0xFF388E3C) : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        // If highlighted, show Blue Border. Else, show thin Grey border.
        border: isHighlighted 
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          Text(
            points,
            style: TextStyle(
              color: pointsColor, // Dynamic Color (Green or Red)
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}