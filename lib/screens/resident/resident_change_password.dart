import 'package:flutter/material.dart';
import 'resident_edit_profile.dart'; // For Back Navigation

class ResidentChangePasswordScreen extends StatefulWidget {
  const ResidentChangePasswordScreen({super.key});

  @override
  State<ResidentChangePasswordScreen> createState() => _ResidentChangePasswordScreenState();
}

class _ResidentChangePasswordScreenState extends State<ResidentChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);
  final Color primaryGreen = const Color(0xFF2ECC71);

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

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
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ResidentEditProfileScreen()),
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("Change Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // FORM
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(25),
                physics: const BouncingScrollPhysics(),
                children: [
                  Text(
                    "Create a strong password with at least 8 characters, including uppercase, lowercase, numbers, and special characters.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Current Password"),
                        _buildPasswordField(
                          controller: _currentPasswordController,
                          hint: "Enter current password",
                          isObscured: _obscureCurrent,
                          toggleVisibility: () => setState(() => _obscureCurrent = !_obscureCurrent),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Current password is required";
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("New Password"),
                        _buildPasswordField(
                          controller: _newPasswordController,
                          hint: "Enter new password",
                          isObscured: _obscureNew,
                          toggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "New password is required";
                            if (value.length < 8) return "Must be at least 8 characters";
                            if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) return "Need at least 1 lowercase letter";
                            if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return "Need at least 1 uppercase letter";
                            if (!RegExp(r'(?=.*\d)').hasMatch(value)) return "Need at least 1 number";
                            if (!RegExp(r'(?=.*[\W])').hasMatch(value)) return "Need at least 1 special character (@#\$%^&*)";
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        _buildLabel("Confirm New Password"),
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          hint: "Confirm new password",
                          isObscured: _obscureConfirm,
                          toggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Please confirm password";
                            if (value != _newPasswordController.text) return "Passwords do not match";
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password Updated Successfully!")));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const ResidentEditProfileScreen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 5,
                        shadowColor: primaryGreen.withValues(alpha: 0.4),
                      ),
                      child: const Text("Update Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 5),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscured,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscured,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500], size: 20),
        suffixIcon: IconButton(
          icon: Icon(isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey[500], size: 20),
          onPressed: toggleVisibility,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}