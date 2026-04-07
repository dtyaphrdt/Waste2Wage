import 'package:flutter/material.dart';
import 'hauler_mainhome.dart';

class EcoPointsMainScreen extends StatefulWidget {
  const EcoPointsMainScreen({super.key});

  @override
  State<EcoPointsMainScreen> createState() => _EcoPointsMainScreenState();
}

class _EcoPointsMainScreenState extends State<EcoPointsMainScreen> {
  bool isRewardsSelected = true;

  // Data for Rewards Tab
  final List<Map<String, dynamic>> rewardsData = [
    {"title": "Cash Out (₱100 GCash)", "sub": "Today • Limited Reward", "pts": "-500 EP", "isRedeemable": false},
    {"title": "Safety Gear Pack", "sub": "Today • Vest + Gloves Included", "pts": "-2000 EP", "isRedeemable": false},
    {"title": "1-Week Fee Waiver", "sub": "Today • 0% Platform Fees", "pts": "-1500 EP", "isRedeemable": false},
    {"title": "Perfect Week Completed", "sub": "Yesterday", "pts": "+15 EP", "isRedeemable": null},
    {"title": "5-Star Rating Received", "sub": "Yesterday", "pts": "+10 EP", "isRedeemable": null},
  ];

  // Data for History Tab
  final List<Map<String, dynamic>> historyData = [
    {"title": "5-Star Rating Bonus", "sub": "Receive a perfect rating from a customer", "pts": "+10 EP", "status": "Redeemed"},
    {"title": "Perfect Week Reward 🏆", "sub": "Complete 10 jobs in a week with zero disputes", "pts": "+100 EP", "status": "Redeem"},
    {"title": "5-Star Rating Bonus", "sub": "Receive a perfect rating from a customer", "pts": "+10 EP", "status": "Redeemed"},
    {"title": "Perfect Week Reward 🏆", "sub": "Complete 10 jobs in a week with zero disputes", "pts": "+100 EP", "status": "Redeem"},
    {"title": "Perfect Week Reward 🏆", "sub": "Complete 10 jobs in a week with zero disputes", "pts": "+100 EP", "status": "Redeem"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 20),
                  _buildToggleSwitch(),
                  const SizedBox(height: 20),
                  _buildContentList(), // Replaces _buildEmptyState
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFDFF6DD),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32), size: 30),
            onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HaulerMainHome()),
                  );
                },
          ),
          const Text('View Eco-Points',
              style: TextStyle(color: Color(0xFF2E7D32), fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFF26BB86), Color(0xFF1E9B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Eco-Points Balance',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.eco, color: Colors.white, size: 30),
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('150', style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text('EP', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white24, thickness: 1),
          Row(
            children: [
              _buildMiniStat(Icons.south_west, "Earned", "0 EP"),
              const Spacer(),
              _buildMiniStat(Icons.north_east, "Redeemed", "0 EP"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(icon, color: Colors.white, size: 14)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        )
      ],
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _buildToggleItem("Rewards", isRewardsSelected),
          _buildToggleItem("History", !isRewardsSelected),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isRewardsSelected = (title == "Rewards")),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: active ? Colors.black : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentList() {
    final data = isRewardsSelected ? rewardsData : historyData;
    return Column(
      children: data.map((item) => _buildListItem(item)).toList(),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    bool isNegative = item['pts'].toString().contains('-');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  item['sub'],
                  style: TextStyle(
                    color: item['sub'].toString().contains('Limited') || item['sub'].toString().contains('Vest')
                        ? Colors.green
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isRewardsSelected)
            Text(
              item['pts'],
              style: TextStyle(
                color: isNegative ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFC8E6C9), borderRadius: BorderRadius.circular(8)),
                  child: Text(item['pts'], style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: item['status'] == "Redeem" ? const Color(0xFF2E7D32) : const Color(0xFFC8E6C9),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      item['status'],
                      style: TextStyle(
                        color: item['status'] == "Redeem" ? Colors.white : const Color(0xFF2E7D32),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}