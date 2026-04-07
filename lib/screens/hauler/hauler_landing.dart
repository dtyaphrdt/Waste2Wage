import 'package:flutter/material.dart';
import 'hauler_login.dart'; // We link this to the Login screen we just finished
import 'hauler_register.dart'; // We will enable this in the next step!

class HaulerLandingScreen extends StatelessWidget {
  const HaulerLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color bgCream = const Color(0xFFFFF8F3);
    final Color primaryGreen = const Color(0xFF388E3C);
    final Color decorationGreen = const Color(0xFFD6F3D7);

    return Scaffold(
      backgroundColor: bgCream,
      body: Stack(
        children: [
          // --- DECORATION (Left Green Blob) ---
          Positioned(
            top: 250,
            left: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: decorationGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // 1. LOGO
                  SizedBox(
                    height: 200,
                    child: Image.asset('assets/images/w2w_logo.png'),
                  ),

                  const SizedBox(height: 40),

                  // 2. MAIN TEXT
                  Text(
                    "\nBe the hero our community needs.\nBrowse available pickup requests,\nhelp residents clear their space,\nand get rewarded for every successful haul.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryGreen,
                      height: 1.5, // Adds nice spacing between lines
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(), // Pushes buttons to the bottom area

                  // 3. GET STARTED BUTTON (Goes to Register)
                  ElevatedButton(
                    onPressed: () {
                      // THIS LINE MAKES THE IMPORT "USED":
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HaulerRegisterScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Started",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 4. ALREADY HAVE ACCOUNT BUTTON (Goes to Login)
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to the Login Screen we just fixed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HaulerLoginScreen()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryGreen, // Green Text
                      side: BorderSide(
                          color: primaryGreen, width: 2), // Green Border
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "I Already Have an Account!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 5. FOOTER TEXT
                  Text(
                    "I accept the job, I get the cash.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryGreen.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
