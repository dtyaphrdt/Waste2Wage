import 'package:flutter/material.dart';
import 'resident_privacypolicy.dart';
import 'resident_aboutw2w.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
                  }, 
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("Terms & Conditions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // CONTENT
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
                    _buildSection("1. Acceptance of Terms", 
                      "By using the Waste2Wage mobile application, you agree to comply with and be bound by these Terms and Conditions. If you do not agree, please do not use the app."),
                    _buildSection("2. Service Description", 
                      "Waste2Wage is a platform that connects residents with local waste haulers for scheduled waste collection. The app allows booking pickups, tracking haulers, and earning Eco-Points for proper waste management."),
                    _buildSection("3. Resident Responsibilities", 
                      "As a resident user, you agree to:\n"
                      "• Provide accurate personal and location information\n"
                      "• Ensure waste is properly prepared for collection\n"
                      "• Follow proper waste segregation guidelines\n"
                      "• Be available during scheduled pickup times\n"
                      "• Treat haulers with respect and professionalism"),
                    _buildSection("4. Fees, Payments, and Wallet", 
                      "• Service fees may apply per booking\n"
                      "• Payments are processed through the app system\n"
                      "• Eco-Points are awarded for completed and proper waste disposal\n"
                      "• Rewards and vouchers are subject to system rules\n"
                      "• Transactions are recorded for transparency"),
                    _buildSection("5. Cancellations and No-Show Policy", 
                      "• Residents may cancel bookings within the allowed time\n"
                      "• Late cancellations may result in penalties\n"
                      "• Repeated no-shows may affect account privileges"),
                    _buildSection("6. Prohibited Activities", 
                      "Residents must not:\n"
                      "• Provide false or misleading information\n"
                      "• Misuse the booking system\n"
                      "• Engage in fraudulent or abusive behavior\n"
                      "• Attempt to manipulate Eco-Points or rewards"),
                    _buildSection("7. Limitation of Liability", 
                      "Waste2Wage is not liable for delays or service interruptions caused by factors beyond control. Users are responsible for proper waste handling and coordination."),
                    _buildSection("8. Modifications to Terms", 
                      "Waste2Wage reserves the right to update these Terms and Conditions at any time. Continued use of the app means you accept any changes."),
                    
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AboutWaste2WageScreen()),
                          );
                        }, 
                        child: Text(
                          "About Waste2Wage", 
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