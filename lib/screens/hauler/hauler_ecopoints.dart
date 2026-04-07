import 'package:flutter/material.dart';
import 'hauler_mainhome.dart';

class EcoPointsGuide extends StatefulWidget {
  const EcoPointsGuide({super.key});

  @override
  State<EcoPointsGuide> createState() => _EcoPointsGuideState();
}

class _EcoPointsGuideState extends State<EcoPointsGuide> {
  // Logic state
  int _currentStep = 1;
  bool _showGuide = true; // Controls which view is visible
  bool _isRewardsSelected = true; // Controls the toggle in main view

  // Step Data for the Guide
  final List<Map<String, dynamic>> _stepsData = [
    {
      "step": 1,
      "title": "Step 1: Receive a 5-Star Rating",
      "desc": "Earn eco-points and tips whenever a customer gives you a perfect rating.",
      "reward": "+10 EP • ₱2.00 Tip",
      "icon": Icons.stars,
    },
    {
      "step": 2,
      "title": "Step 2: Deliver Excellent Service",
      "desc": "Consistent quality service increases your chances of getting bonuses.",
      "reward": "More chances for 5-star ratings + tips",
      "icon": Icons.inventory_2,
    },
    {
      "step": 3,
      "title": "Step 3: Complete Your Perfect Week",
      "desc": "Finish 10 jobs in one week with no disputes to unlock a special milestone reward.",
      "reward": "+100 EP Bonus",
      "icon": Icons.calendar_today,
    },
    {
      "step": 4,
      "title": "Step 4: Earn Your Weekly Bonus",
      "desc": "A Perfect Week gives you an additional payout on top of your earnings.",
      "reward": "₱20.00 Weekly Bonus",
      "icon": Icons.card_giftcard,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildBalanceCard(),
                  const SizedBox(height: 20),
                  // Conditional Rendering: Show Guide or Main Content
                  if (_showGuide) 
                    _buildHowItWorksCard() 
                  else 
                    _buildMainContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SHARED UI COMPONENTS ---

  Widget _buildHeader() {
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
              Text('0', style: TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)),
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

  // --- GUIDE VIEW COMPONENTS ---

  Widget _buildHowItWorksCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('How It Works', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('$_currentStep/4', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          ..._stepsData.map((data) => _buildStepItem(data)).toList(),
          const SizedBox(height: 20),
          _buildGuideButtons(),
        ],
      ),
    );
  }

  Widget _buildStepItem(Map<String, dynamic> data) {
    bool isActive = data['step'] == _currentStep;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(15),
        border: isActive ? Border.all(color: const Color(0xFF4CAF50), width: 1) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isActive ? const Color(0xFF2E7D32) : Colors.transparent,
                child: Icon(data['icon'], color: isActive ? Colors.white : Colors.black54),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  data['title'],
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (isActive) ...[
            const SizedBox(height: 10),
            Text(data['desc'], style: const TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFC8E6C9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32), size: 18),
                  const SizedBox(width: 8),
                  Text(data['reward'],
                      style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildGuideButtons() {
    if (_currentStep == 4) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => setState(() => _showGuide = false),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text("Got It, Let's Go!", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _showGuide = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC5D9F9),
              foregroundColor: Colors.blue.shade800,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Skip Guide', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_currentStep < 4) _currentStep++;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            child: const Text('Next Step', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  // --- MAIN CONTENT VIEW COMPONENTS ---

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildToggleSwitch(),
        const SizedBox(height: 60),
        _buildEmptyState(),
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
          _buildToggleItem("Rewards", _isRewardsSelected),
          _buildToggleItem("History", !_isRewardsSelected),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isRewardsSelected = (title == "Rewards")),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                : [],
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

  Widget _buildEmptyState() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade300,
          child: Icon(
            _isRewardsSelected ? Icons.card_giftcard : Icons.access_time,
            size: 40,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isRewardsSelected ? "No rewards available yet" : "No history yet",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            _isRewardsSelected
                ? "Complete more jobs to unlock rewards!"
                : "Your earned points will appear here",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}