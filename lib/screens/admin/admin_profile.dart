import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this to pubspec.yaml
import 'dart:io';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color bgLight = const Color(0xFFF8FAF9);
  final Color textDark = const Color(0xFF2C3E50);

  // Controllers for Personal Info
  final TextEditingController _nameController = TextEditingController(text: "Admin User");
  final TextEditingController _emailController = TextEditingController(text: "admin@waste2wage.com");
  final TextEditingController _phoneController = TextEditingController(text: "+63 912 345 6789");

  // Controllers for Password
  final TextEditingController _currentPassController = TextEditingController(text: "password123");
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  // State Variables
  bool _obscurePassword = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _displayName = "Admin User";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // --- FUNCTIONALITY: Image Upload ---
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _showSuccessMessage("Profile picture updated successfully!");
    }
  }

  // --- FUNCTIONALITY: Save Changes ---
  void _handleSaveChanges() {
    setState(() {
      _displayName = _nameController.text;
    });
    _showSuccessMessage("Personal information updated successfully!");
  }

  // --- FUNCTIONALITY: Update Password ---
  void _handleUpdatePassword() {
    if (_newPassController.text.isNotEmpty && _newPassController.text == _confirmPassController.text) {
      _showSuccessMessage("Password changed successfully!");
      _newPassController.clear();
      _confirmPassController.clear();
    } else if (_newPassController.text != _confirmPassController.text) {
      _showErrorMessage("Passwords do not match!");
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
        width: 400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, width: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("My Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text("Manage your account information and security", style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _buildUserOverviewCard()),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildPersonalInfoCard(),
                  const SizedBox(height: 24),
                  _buildPasswordCard(),
                  const SizedBox(height: 24),
                  _buildLoginActivityCard(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryGreen.withOpacity(0.1),
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null 
                  ? Text(_displayName.substring(0, 1).toUpperCase(), style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen))
                  : null,
              ),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(_displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(_emailController.text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 14, color: primaryGreen),
              const SizedBox(width: 4),
              Text("Super Admin", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const Divider(height: 40),
          _buildInfoRow("Phone", _phoneController.text),
          _buildInfoRow("Member Since", "January 15, 2024"),
          _buildInfoRow("Last Login", "Today, 9:42 AM"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(width: double.infinity),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return _profileCard(
      title: "Personal Information",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _profileTextField("Full Name", _nameController)),
              const SizedBox(width: 16),
              Expanded(child: _profileTextField("Email Address", _emailController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _profileTextField("Phone Number", _phoneController)),
              const SizedBox(width: 16),
              Expanded(child: _profileTextField("Role", TextEditingController(text: "Super Admin"), enabled: false)),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _handleSaveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text("Save Changes"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard() {
    return _profileCard(
      title: "Change Password",
      icon: Icons.lock_outline,
      child: Column(
        children: [
          _profileTextField("Current Password", _currentPassController, isPassword: true),
          const SizedBox(height: 16),
          _profileTextField("New Password", _newPassController, isPassword: true),
          const SizedBox(height: 16),
          _profileTextField("Confirm New Password", _confirmPassController, isPassword: true),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _handleUpdatePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text("Update Password"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginActivityCard() {
    return _profileCard(
      title: "Login Activity",
      child: Column(
        children: [
          _loginActivityTile("Chrome on Windows", "192.168.1.100 - Today, 9:42 AM", isCurrent: true),
          _loginActivityTile("Chrome on MacOS", "10.0.0.55 - Mar 12, 2:30 PM"),
        ],
      ),
    );
  }

  Widget _loginActivityTile(String device, String details, {bool isCurrent = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(device.contains("iPhone") ? Icons.smartphone : Icons.computer, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("IP: $details", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          isCurrent 
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text("Current", style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
              )
            : TextButton(onPressed: () {}, child: const Text("Revoke", style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _profileCard({required String title, required Widget child, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _profileTextField(String label, TextEditingController controller, {bool isPassword = false, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          obscureText: isPassword ? _obscurePassword : false,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18, color: Colors.grey),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ) 
              : null,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
        ),
      ],
    );
  }
}