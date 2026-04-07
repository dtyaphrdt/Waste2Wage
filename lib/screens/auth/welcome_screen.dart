import 'package:flutter/material.dart';
import 'package:waste2wage/screens/hauler/hauler_landing.dart';
import '../../screens/resident/resident_landing.dart'; 

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // COLORS
    final Color bgCream = const Color(0xFFFFF8F3);
    final Color primaryGreen = const Color(0xFF388E3C);
    final Color decorationGreen = const Color(0xFFD6F3D7);

    return Scaffold(
      backgroundColor: bgCream,
      body: Stack(
        children: [
          // --- DECORATION 1 (Top Left Circle) ---
          Positioned(
            top: 150,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: decorationGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // --- DECORATION 2 (Bottom Right Circle) ---
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: decorationGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20), 

                    // 1. THE LOGO (Kept Big at 350)
                    SizedBox(
                      height: 350, 
                      child: Image.asset(
                        'assets/images/w2w_logo.png',
                        fit: BoxFit.contain, // Ensures the whole logo is visible
                      ),
                    ),

                    // 2. THE CONTENT (Pulled UP by 50 pixels to fix the gap)
                    // We use Transform.translate to ignore the empty space in the image
                    Transform.translate(
                      offset: const Offset(0, -50), // <--- CHANGE THIS NUMBER to move text up/down
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // THE WELCOME TEXT
                          const Text(
                            "Welcome to,\nWaste2Wage",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2E7D32),
                              height: 1.1,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // THE SUBTITLE
                          const Text(
                            "Select your role to\naccess your dashboard",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 30), 

                          // RESIDENT BUTTON
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const ResidentLandingScreen()),
                              );
                            },
                            icon: const Icon(Icons.home_outlined, size: 28),
                            label: const Text(
                              "Resident",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // HAULER BUTTON
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const HaulerLandingScreen()),
                              );
                            },
                            icon: const Icon(Icons.person_outline, size: 28),
                            label: const Text(
                              "Hauler",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}