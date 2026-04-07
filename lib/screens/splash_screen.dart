import 'package:flutter/material.dart';
import 'dart:async'; // For the Timer
import 'auth/welcome_screen.dart'; // Import your next screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. SETUP THE ANIMATION
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1500), // Speed of expansion (1.5 seconds)
    );

    // The circle will grow from Size 1 (normal) to Size 30 (huge, covering screen)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 2. START ANIMATION
    // We wait a tiny bit, then start expanding
    Timer(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    // 3. NAVIGATE WHEN DONE
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Wait a split second on the full green screen, then go to Welcome
        Timer(const Duration(milliseconds: 300), () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const WelcomeScreen(),
              transitionDuration: const Duration(milliseconds: 800),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Starting background
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // This stack keeps the logo 'floating' while the green background grows behind it
            return Stack(
              alignment: Alignment.center,
              children: [
                // THE GROWING GREEN CIRCLE
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 100, // Initial size of the green circle
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.green, // Your brand color
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // THE LOGO (Stays in the center)
                SizedBox(
                  width: 450, // Adjust this number if the logo is too small/big
                  height: 450,
                  child: Image.asset('assets/images/w2w_logo.png'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
