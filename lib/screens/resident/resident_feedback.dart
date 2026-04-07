import 'package:flutter/material.dart';
import 'resident_home.dart';

class ResidentFeedbackScreen extends StatefulWidget {
  const ResidentFeedbackScreen({super.key});

  @override
  State<ResidentFeedbackScreen> createState() => _ResidentFeedbackScreenState();
}

class _ResidentFeedbackScreenState extends State<ResidentFeedbackScreen> {
  // --- COLORS BASED ON IMAGE ---
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color buttonGreen = const Color(0xFF2EAB33); // Darker green from image
  final Color textGrey = const Color(0xFF757575);
  final Color borderLight = const Color(0xFFE0E0E0);

  int _selectedRating = 0;
  String? _selectedBadge;
  Set<String> _selectedIssues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: SingleChildScrollView( // Added to handle longer content
        child: Column(
          children: [
            // 1. HEADER
            Container(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
              decoration: BoxDecoration(
                color: headerGreen,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
                      );
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.green, size: 28),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Rate Your Hauler",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 2. HAULER INFO CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderLight),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFFD9D9D9),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Juan Santos",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const Text(" 4.8", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(" (150 jobs)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 3. RATING SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderLight),
                ),
                child: Column(
                  children: [
                    const Text(
                      "How was your waste collection experience?",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        bool isSelected = _selectedRating > index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedRating = index + 1),
                          child: Icon(
                            Icons.star,
                            color: isSelected ? Colors.amber : const Color(0xFFD9D9D9),
                            size: 45,
                          ),
                        );
                      }),
                    ),
                    if (_selectedRating > 0) ...[
                      const SizedBox(height: 10),
                      Text(
                        _selectedRating >= 4 ? "Glad you had a great experience!" : "We're sorry to hear that",
                        style: TextStyle(color: textGrey, fontSize: 12),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // 4. DYNAMIC SECTION
            if (_selectedRating >= 1 && _selectedRating <= 3) _buildNegativeFeedback(),
            if (_selectedRating >= 4) _buildPositiveBadges(),

            const SizedBox(height: 20),

            // 5. SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // 1. Create the dynamic message based on rating
                  String secondaryText = "";
                  if (_selectedRating >= 4) {
                    int badgeCount = _selectedBadge != null ? 1 : 0;
                    secondaryText = "You rated Juan Santos $_selectedRating stars and $badgeCount badge";
                  } else {
                    secondaryText = "You rated Juan Santos $_selectedRating stars and ${_selectedIssues.length} issues";
                  }

                  // 2. Show the Pop-up
                  showDialog(
                    context: context,
                    barrierDismissible: false, // User must wait for auto-redirect
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Rating Submitted!",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                secondaryText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  // 3. Automatically direct to home screen after 2.5 seconds
                  Future.delayed(const Duration(milliseconds: 2500), () {
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
                        (route) => false, // Clears the navigation stack
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EAB33),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text("Submit Rating", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentHomeScreen()));
              },
              child: Text("Skip", style: TextStyle(color: textGrey, fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET FOR 1-3 STARS ---
  Widget _buildNegativeFeedback() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Improvements Needed", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const Text("Select issues you encountered during this pickup", style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 15),
        
        // Clickable Chips
        _feedbackChip("Messy Collection (Makalat)"),
        _feedbackChip("Late Arrival (Matagal Dumating)"),
        _feedbackChip("Did not show up (Hindi Sumipot)"),
        
        const SizedBox(height: 20),
        const Text("Additional Comments / Suggestions", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
        const SizedBox(height: 10),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Share more details about your experience or suggestions for improvement...",
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), 
              borderSide: BorderSide(color: borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), 
              borderSide: BorderSide(color: borderLight),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        const SizedBox(height: 15),
        
        // Red Warning Box from Image
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE), 
            borderRadius: BorderRadius.circular(12), 
            border: Border.all(color: const Color(0xFFFFCDD2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: Colors.red, size: 22),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "We appreciate your response. We review all low ratings to help our haulers provide the best service possible for Barangay Sauyo.", 
                  style: TextStyle(fontSize: 11, color: Color(0xFFB71C1C), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

  // --- WIDGET FOR 4-5 STARS ---
  Widget _buildPositiveBadges() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Award Performance Badges", 
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)
          ),
          const Text(
            "Select badges that best describe this hauler's performance", 
            style: TextStyle(fontSize: 12, color: Colors.grey)
          ),
          const SizedBox(height: 15),
          _badgeCard(
            "Green Guardian", 
            "Accurate and careful handling for segregated waste.", 
            Icons.shield_outlined, 
            "Green Guardian",
            ["Messy Collection (Makalat)", "Properly Handled (Maayos sa Basura)"]
          ),
          _badgeCard(
            "Speedster", 
            "Fast and efficient arrival", 
            Icons.bolt_outlined, 
            "Speedster",
            ["Fast Arrival (mabilis dumating)", "Prompt Service (maagap)"]
          ),
          _badgeCard(
            "Reliability King", 
            "Dependable and smooth service", 
            Icons.workspace_premium_outlined, 
            "Reliability King",
            ["Highly Dependable (Maasahan)", "Smooth Transaction (Madaling Kausap)"]
          ),
        ],
      ),
    );
  }

  Widget _feedbackChip(String label) {
  bool isSelected = _selectedIssues.contains(label);
  
  return GestureDetector(
    onTap: () {
      setState(() {
        if (isSelected) {
          _selectedIssues.remove(label);
        } else {
          _selectedIssues.add(label);
        }
      });
    },
    child: Container(
      width: double.infinity, // Matches the full-width look in the image
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        // If selected, use the red theme from the image, otherwise white/grey
        color: isSelected ? const Color(0xFFFFEBEE) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isSelected ? Colors.red : borderLight,
          width: 1.5,
        ),
      ),
      child: Text(
        label, 
        style: TextStyle(
          color: isSelected ? Colors.red : Colors.black, 
          fontSize: 13, 
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    ),
  );
}

  Widget _badgeCard(String title, String desc, IconData icon, String value, List<String> tags) {
    bool isSelected = _selectedBadge == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedBadge = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.5) : borderLight,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gray Circular Icon
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? const Color(0xFF4CAF50) : Colors.grey, size: 28),
            ),
            const SizedBox(width: 15),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  
                  // Small Tag Chips inside the card
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFC8E6C9) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 9, 
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade600
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
            
            // Radio/Check Indicator
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}