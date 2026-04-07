import 'package:flutter/material.dart';
import 'resident_terms&conditions.dart';
import 'resident_help&support.dart';

class AboutWaste2WageScreen extends StatelessWidget {
  const AboutWaste2WageScreen({super.key});

  // Theme colors consistent with other policy screens
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);
  final Color cardGreen = const Color(0xFFE8F5E9); // Light green for What We Offer icons

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: headerGreen,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TermsConditionsScreen()));
                  }, 
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("About Waste2Wage", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // SCROLLABLE CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. About section in a white card
                _buildWhiteCard([
                  _buildSectionTitle("About Waste2Wage"),
                  _buildSectionBody(
                    "Waste2Wage is a mobile application designed to improve waste collection in Barangay Sauyo, Quezon City. It allows residents to easily schedule waste pickups (Pa-Hakot), track haulers in real time, and earn Eco-Points through proper waste management. The system promotes cleaner communities by combining convenience, technology, and rewards."
                  ),
                ]),
                const SizedBox(height: 15),

                // 2. Our Mission
                _buildWhiteCard([
                  _buildSectionTitle("Our Mission"),
                  _buildSectionBody(
                    "Our mission is to provide residents with a convenient and reliable waste collection system while encouraging responsible waste segregation. Through digital tools and Eco-Point incentives, Waste2Wage aims to reduce uncollected waste and increase community participation in sustainable practices."
                  ),
                ]),
                const SizedBox(height: 15),

                // 3. How It Works
                _buildWhiteCard([
                  _buildSectionTitle("How It Works for Residents"),
                  _buildSectionBody(
                    "• Schedule a Pa-Hakot (waste pickup request) anytime\n"
                    "• Set your preferred pickup date and time\n"
                    "• Get matched with a verified hauler\n"
                    "• Track the hauler using real-time GPS\n"
                    "• Prepare and segregate your waste properly\n"
                    "• Confirm pickup and view Proof of Service\n"
                    "• Earn Eco-Points after successful collection\n"
                    "• Rate the hauler and track your activity"
                  ),
                ]),
                const SizedBox(height: 15),

                // 4. What We Offer
                _buildWhiteCard([
                  _buildSectionTitle("What We Offer"),
                  const SizedBox(height: 15),
                  // Using ListTiles for the icons and text
                  _buildOfferItem(Icons.calendar_today, "Easy Pickup Scheduling", "Book waste collection anytime based on your availability"),
                  _buildOfferItem(Icons.verified, "Verified Haulers", "Only trusted and verified collectors handle your waste"),
                  _buildOfferItem(Icons.location_on, "Real-Time Tracking", "Monitor hauler location and arrival status"),
                  _buildOfferItem(Icons.stars, "Eco-Points Rewards System", "Earn points for proper waste management"),
                  _buildOfferItem(Icons.notifications, "Notifications & Updates", "Receive real-time alerts for bookings and status"),
                  _buildOfferItem(Icons.security, "Secure Transactions", "Safe and monitored system with admin validation"),
                  _buildOfferItem(Icons.touch_app, "User-Friendly Interface", "Simple and easy-to-use design for all users"),
                ]),
                const SizedBox(height: 15),

                // 5. Resident Benefits
                _buildWhiteCard([
                  _buildSectionTitle("Resident Benefits"),
                  _buildSectionBody(
                    "• No need to bring trash to collection points\n"
                    "• Convenient door-to-door waste pickup\n"
                    "• Cleaner and healthier environment\n"
                    "• Rewards for responsible waste segregation\n"
                    "• Real-time updates and better coordination\n"
                    "• Increased trust through verified haulers"
                  ),
                ]),
                
                const SizedBox(height: 20),
                // Text button at the bottom right
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigates to the Help & Support Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                      );
                    }, 
                    child: Text(
                      "Help & Support", 
                      style: TextStyle(color: textGreen, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods to keep the structure clean

  Widget _buildWhiteCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));
  }

  Widget _buildSectionBody(String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(content, style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5)),
    );
  }

  Widget _buildOfferItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Styled icon container matching image
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: cardGreen, borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: textGreen, size: 24),
          ),
          const SizedBox(width: 15),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.3)),
              ],
            ),
          )
        ],
      ),
    );
  }
}