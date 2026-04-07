import 'package:flutter/material.dart';
import 'resident_aboutw2w.dart';
import 'resident_FAQs.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);
  final Color cardGreen = const Color(0xFFE8F5E9); // Light green for What We Can Help items

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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AboutWaste2WageScreen()));
                  }, 
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("Help & Support", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                Text(
                  "We’re here to assist you with concerns related to your waste pickup, bookings, payments, and Eco-Points.",
                  style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 20),

                // 1. Support Hours in a white card
                _buildWhiteCard([
                  _buildIconTitleRow(Icons.access_time_filled, "Support Hours"),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 40), // Align with title text
                    child: Text(
                      "Mon – Fri: 8AM – 5PM | Sat – Sun: 9AM – 5PM",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ]),
                const SizedBox(height: 15),

                const Text("CONTACT US", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 15),

                // 2. Email Support
                _buildWhiteCard([
                  _buildIconTitleRow(Icons.email, "Email Support"),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "For general concerns, complaints, or technical issues, you may email us at:\n"
                      "support@waste2wage.com",
                      style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.3),
                    ),
                  ),
                ]),
                const SizedBox(height: 15),

                // 3. Phone Support
                _buildWhiteCard([
                  _buildIconTitleRow(Icons.phone, "Phone Support"),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "For urgent concerns such as missed pickups or booking issues, you may call:\n"
                      "+63 912 345 6789\n"
                      "Available during support hours",
                      style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.3),
                    ),
                  ),
                ]),
                const SizedBox(height: 15),

                // 4. What We Can Help and Quick Tips
                _buildWhiteCard([
                  _buildSectionTitle("What We Can Help You With"),
                  _buildSectionBody(
                    "• Scheduling or rescheduling pickups\n"
                    "• Missed or delayed collections\n"
                    "• Issues with assigned haulers\n"
                    "• Eco-Points and rewards concerns\n"
                    "• Payment or booking issues\n"
                    "• Account and profile concerns\n"
                    "• Reporting waste-related problems"
                  ),
                  const SizedBox(height: 15),
                  _buildSectionTitle("Quick Tips for Faster Assistance"),
                  _buildSectionBody(
                    "• Clearly describe your issue\n"
                    "• Include your booking details or screenshots\n"
                    "• Make sure your app is updated\n"
                    "• Check notifications for updates before reporting"
                  ),
                ]),
                const SizedBox(height: 15),

                Text(
                  "We are committed to providing a safe, reliable, and convenient waste collection service for all residents.",
                  style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
                ),
                
                const SizedBox(height: 20),
                // Text button at the bottom right
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigates to the FAQs Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FaqsScreen()),
                      );
                    }, 
                    child: Text(
                      "FAQs", 
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildIconTitleRow(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: textGreen, size: 24),
        const SizedBox(width: 15),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
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
}