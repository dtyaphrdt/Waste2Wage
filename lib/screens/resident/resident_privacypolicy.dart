import 'package:flutter/material.dart';
import 'resident_profile.dart';
import 'resident_terms&conditions.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);

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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentProfileScreen()));
                  }, 
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("Privacy Policy", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // POLICY CONTENT
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last updated: December 1, 2025",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    _buildSection("1. Introduction", 
                      "Welcome to Waste2Wage. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, and safeguard your data when you use the application."),
                    _buildSection("2. Information We Collect", 
                      "We collect information that you provide directly to us, including:\n"
                      "• Name, email address, and phone number\n"
                      "• Pinned address for pickup services\n"
                      "• Payment and booking information\n"
                      "• Transaction history and Eco-Points data\n"
                      "• Device and location data"),
                    _buildSection("3. How We Use Your Information", 
                      "We use your information to:\n"
                      "• Schedule and manage waste pickup requests\n"
                      "• Match you with nearby haulers\n"
                      "• Provide real-time tracking and notifications\n"
                      "• Process Eco-Points and rewards\n"
                      "• Improve app performance and user experience"),
                    _buildSection("4. Data Sharing", 
                      "We do not sell your personal information. Your data is only shared with assigned haulers during confirmed bookings and with authorized personnel for system operations."),
                    _buildSection("5. Data Security", 
                      "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, loss, or misuse."),
                    _buildSection("6. Contact Us", 
                      "If you have questions about this Privacy Policy, please contact us at:\n"
                      "📧 privacy@waste2wage.com"),
                    
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigates to the Terms & Conditions Screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
                          );
                        }, 
                        child: Text(
                          "Terms & Condition", 
                          style: TextStyle(color: textGreen, decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}