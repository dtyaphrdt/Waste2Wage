import 'package:flutter/material.dart';
import 'resident_register.dart'; 
import 'resident_home.dart'; // <--- Make sure this file exists and has no red errors!

class ResidentLoginScreen extends StatefulWidget {
  const ResidentLoginScreen({super.key});

  @override
  State<ResidentLoginScreen> createState() => _ResidentLoginScreenState();
}

class _ResidentLoginScreenState extends State<ResidentLoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color bgCream = const Color(0xFFFFF8F3);
    final Color primaryGreen = const Color(0xFF388E3C);
    final Color decorationGreen = const Color(0xFFD6F3D7);

    return Scaffold(
      backgroundColor: bgCream,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // --- DECORATION ---
          Positioned(
            top: 300,
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
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LOGO
                    Center(
                      child: SizedBox(
                        height: 100,
                        // Make sure this image exists, or wrap in try/catch if crashing
                        child: Image.asset('assets/images/w2w_logo.png', 
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.recycling, size: 80, color: Colors.green),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // TITLE
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // SUBTITLE
                    Text(
                      "Log in to schedule your next pickup and manage\nyour waste collection requests.",
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryGreen.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 25),

                    // INPUTS
                    _buildTextField(
                      label: "Username",
                      icon: Icons.person_outline,
                      hint: "Enter your username",
                    ),

                    const SizedBox(height: 15),

                    _buildTextField(
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      hint: "you@example.com",
                    ),

                    const SizedBox(height: 15),

                    // Password Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Password",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green)),
                        const SizedBox(height: 5),
                        TextField(
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Login Button
                    ElevatedButton(
                      onPressed: () {
                        print("Login Button Pressed!"); // <--- Check your debug console for this!
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
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
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // --- SMALLER BOTTOM TEXT ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't you have an account? ",
                            style: TextStyle(fontSize: 12)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ResidentRegisterScreen()),
                            );
                          },
                          child: Text(
                            "Create an Account",
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required String label, required IconData icon, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.green)),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12),
            ),
          ),
        ),
      ],
    );
  }
}