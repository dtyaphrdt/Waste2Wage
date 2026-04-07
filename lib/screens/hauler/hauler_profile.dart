import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'hauler_login.dart';
class HaulerProfile extends StatelessWidget {
  const HaulerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB), // Light peach background
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: [
                  // Main User Info Card
                  _buildUserMainCard(),
                  const SizedBox(height: 20),

                  _buildMenuTile(context, Icons.person_outline, "Personal Information", "View your info", const PersonalInformationScreen()),
                  _buildMenuTile(context, Icons.shield_outlined, "Valid ID", "View your Valid ID", const ValidIDScreen()),
                  _buildMenuTile(context, Icons.directions_bike, "Vehicle Photo", "View your vehicle photo", const VehiclePhotoScreen()),
                  _buildMenuTile(context, Icons.settings_outlined, "Settings", "Manage app settings", const SettingsScreen()),

                  const SizedBox(height: 30),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HaulerLoginScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Curved Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, left: 10, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFDFF6DD),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32), size: 30),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            }
          ),
          const SizedBox(width: 8),
          const Text(
            'Profile',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  // User Badge Card
  Widget _buildUserMainCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade200, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_outline, size: 50, color: Colors.green),
                ),
              ),
              const SizedBox(width: 20),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Juan Dela Cruz", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.directions_bike, size: 18, color: Colors.grey),
                      SizedBox(width: 4),
                      Text("Cyclist Hauler", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                  Text("(hauler number)  * Max 10", style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text("Verified", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Updated Helper Method
  Widget _buildMenuTile(BuildContext context, IconData icon, String title, String subtitle, Widget targetScreen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFDFF6DD), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.green.shade700),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)),
      ),
    );
  }
}

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Personal Information"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(radius: 52, backgroundColor: Colors.white, child: Icon(Icons.person_outline, size: 60, color: Colors.green)),
                  ),
                  const SizedBox(height: 10),
                  const Text("Juan Dela Cruz", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Cyclist Hauler", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 20),
                  _infoCard(Icons.person_outline, "Full Name", "Juan Dela Cruz"),
                  _infoCard(Icons.email_outlined, "Email", "juandelacruz@gmail.com"),
                  _infoCard(Icons.phone_outlined, "Phone", "09087654321"),
                  _infoCard(Icons.calendar_today_outlined, "Age", "27 years old"),
                  _infoCard(Icons.location_on_outlined, "Address", "123 St., Brgy. Sauyo"),
                  _infoCard(Icons.tag, "Hauler ID", "#"),
                  _infoCard(Icons.track_changes, "Max Jobs", "10 Jobs"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFFDFF6DD), child: Icon(icon, color: Colors.green)),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ]),
        ],
      ),
    );
  }
}
// --- VALID ID SCREEN CLASS ---
class ValidIDScreen extends StatelessWidget {
  const ValidIDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB), // Light peach background
      body: Column(
        children: [
          _buildHeader(context, "Valid ID"),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusBanner("Your ID has been verified successfully"),
                const SizedBox(height: 25),
                const Text("FRONT OF ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                const DashedBox(),
                const SizedBox(height: 25),
                const Text("BACK OF ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                const DashedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- VEHICLE PHOTO SCREEN CLASS ---
class VehiclePhotoScreen extends StatelessWidget {
  const VehiclePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Vehicle Photo"),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusBanner("Vehicle photo verified"),
                const SizedBox(height: 25),
                const Text("VEHICLE PHOTO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                const DashedBox(),
                const SizedBox(height: 20),
                // Vehicle Type Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFDFF6DD),
                        child: Icon(Icons.directions_bike, color: Colors.green.shade700),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vehicle Type", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text("Bicycle", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- COMMON COMPONENTS ---

// Dashed Box Widget
class DashedBox extends StatelessWidget {
  const DashedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFDFF6DD).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

// Custom Painter for the dashed lines
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.shade700
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(15)));

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double distance = 0.0;

    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Status Banner Helper
Widget _statusBanner(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFC8E6C9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
        const SizedBox(width: 10),
        Text(text,
          style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    ),
  );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Settings"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _settingsTile(context, Icons.notifications_none, "Notifications", const NotificationsSettingsScreen()),
                _settingsTile(context, Icons.lock_outline, "Change Password", const ChangePasswordScreen()),
                _settingsTile(context, Icons.person_outline, "Edit Contact Info", const EditContactInfoScreen()),
                _settingsTile(context, Icons.error_outline, "Submit Issue", const SubmitIssueScreen()),
                _settingsTile(context, Icons.chat_bubble_outline, "Contact Admin", const ContactAdminScreen()),
                _settingsTile(context, Icons.description_outlined, "Terms & Conditions", const TermsConditionsScreen()),
                _settingsTile(context, Icons.verified_user_outlined, "Privacy Policy", const PrivacyPolicyScreen()),
                _settingsTile(context, Icons.info_outline, "About Waste2Wage", null), // Add screen if needed
                const SizedBox(height: 20),
                _logoutButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(BuildContext context, IconData icon, String title, Widget? target) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFFDFF6DD), child: Icon(icon, color: Colors.green)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (target != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => target));
          }
        },
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Color(0xFFFFEBEE), child: Icon(Icons.logout, color: Colors.red)),
        title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HaulerLoginScreen()),
            (route) => false,
          );
        },
      ),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscured = true; // Toggle for password visibility

  // --- NEW FIXED METHOD ---
  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  void _handleUpdatePassword() {
    String current = _currentPasswordController.text;
    String newPass = _newPasswordController.text;
    String confirm = _confirmPasswordController.text;

    // Validation Logic
    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      _showMessage("Please fill in all fields", Colors.red);
      return;
    }

    if (newPass.length < 8 || !RegExp(r'^(?=.*[A-Z])(?=.*[0-9])').hasMatch(newPass)) {
      _showMessage("Password must be 8+ chars, with 1 uppercase and 1 number", Colors.red);
      return;
    }

    if (newPass != confirm) {
      _showMessage("New passwords do not match", Colors.red);
      return;
    }

    // Success logic
    _showMessage("Password updated successfully!", Colors.green);
    Navigator.pop(context);
  }

  void _showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Change Password"),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Keep your account secure with a strong password", style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 25),
                _inputLabel("Current Password"),
                _passwordField("Enter current password", _currentPasswordController),
                const SizedBox(height: 15),
                _inputLabel("New Password"),
                _passwordField("Enter new password", _newPasswordController),
                const SizedBox(height: 15),
                _inputLabel("Confirm New Password"),
                _passwordField("Confirm new password", _confirmPasswordController),
                const SizedBox(height: 15),
                const Text(
                  "Password must be at least 8 characters with one uppercase letter and one number.",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 30),
                _greenButton("Update Password", _handleUpdatePassword),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modified helper to include controller and visibility toggle
  Widget _passwordField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _isObscured = !_isObscured),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  // Generic Button Helper
  Widget _greenButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class EditContactInfoScreen extends StatefulWidget {
  const EditContactInfoScreen({super.key});

  @override
  State<EditContactInfoScreen> createState() => _EditContactInfoScreenState();
}

class _EditContactInfoScreenState extends State<EditContactInfoScreen> {
  final TextEditingController _phoneController = TextEditingController(text: "+6398765432");
  final TextEditingController _emailController = TextEditingController(text: "juandelacruz@gmail.com");

  void _saveChanges() {
    if (!_emailController.text.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Email")));
      return;
    }
    // Simulation of data saving
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contact Info Saved!"), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Edit Contact Info"),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Update your contact details for pickup", style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                _editField("Phone Number", _phoneController),
                _editField("Email Address", _emailController),
                // ... apply controllers to the rest of the fields
                const SizedBox(height: 30),
                _greenButton("Save Changes", _saveChanges),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greenButton(String text, VoidCallback action) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 18)),
        onPressed: action,
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class ContactAdminScreen extends StatefulWidget {
  const ContactAdminScreen({super.key});

  @override
  State<ContactAdminScreen> createState() => _ContactAdminScreenState();
}

class _ContactAdminScreenState extends State<ContactAdminScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"sender": "Admin", "time": "10:00 AM", "text": "Hi! 👋 How can we help you today?"},
    {"sender": "Admin", "time": "10:00 AM", "text": "Feel free to describe your issue and we'll assist you as soon as possible."},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "sender": "You",
        "time": "Now",
        "text": _messageController.text.trim(),
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Contact Admin"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          return _chatBubble("${msg['sender']} • ${msg['time']}", msg['text']!);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatBubble(String header, String message) {
    bool isMe = header.contains("You");
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(header, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Container(
          margin: const EdgeInsets.only(top: 4, bottom: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? Colors.green.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(message, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }
}

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Terms & Conditions"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text("Last updated: February 1, 2026", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                _policySection("1. Acceptance of Terms", "By accessing and using the Waste2Wage platform, you agree to be bound by these Terms and Conditions. If you do not agree, please do not use our services."),
                _policySection("2. Service Description", "Waste2Wage connects waste haulers with residents who need waste collection services. We facilitate the matching, scheduling, and payment process."),
                _policySection("3. User Responsibilities", "Users must provide accurate information during registration, maintain their account security, and comply with all local regulations regarding waste collection."),
                _policySection("4. Payment Terms", "Earnings are credited to your wallet upon successful job completion. Cash outs are processed within 24 hours. A small service fee may apply."),
                _policySection("5. Account Termination", "We reserve the right to suspend or terminate accounts that violate these terms, engage in fraudulent activity, or receive repeated complaints."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _policySection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Privacy Policy"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text("Last updated: February 1, 2026", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                _policySection("1. Data Collection", "We collect personal information such as your name, contact details, location data, and identification documents to verify your identity and provide our services."),
                _policySection("2. How We Use Your Data", "Your data is used to match you with available jobs, process payments, verify your identity, and improve our platform. We do not sell your personal information."),
                _policySection("3. Data Security", "We use industry-standard encryption and security measures to protect your data. All sensitive information is stored securely and access is restricted."),
                _policySection("4. Location Data", "We collect location data to show nearby jobs and enable navigation. You can disable location services, but some features may be limited."),
                _policySection("5. Your Rights", "You have the right to access, update, or delete your personal data at any time. Contact our support team for data-related requests."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _policySection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  // State storage for our switches
  final Map<String, bool> _settingsState = {
    "Push Notifications": true,
    "Email Notifications": false,
    "SMS Notifications": false,
    "New Job Alerts": true,
    "Payment Alerts": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Notifications Settings"),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Manage how you receive alerts and updates", 
                  style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                _buildSectionCard("CHANNELS", [
                  _switchTile("Push Notifications", "Receive alerts on your device"),
                  _switchTile("Email Notifications", "Get updates via email"),
                  _switchTile("SMS Notifications", "Receive text messages"),
                ]),
                const SizedBox(height: 20),
                _buildSectionCard("ALERT TYPES", [
                  _switchTile("New Job Alerts", "When a new pickup is available near you"),
                  _switchTile("Payment Alerts", "When you receive earnings or cash out"),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8), 
          child: Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _switchTile(String title, String subtitle) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: _settingsState[title] ?? false, 
        onChanged: (bool newValue) {
          setState(() {
            _settingsState[title] = newValue;
          });
        }, 
        activeColor: Colors.green,
      ),
    );
  }
}

class SubmitIssueScreen extends StatefulWidget {
  const SubmitIssueScreen({super.key});

  @override
  State<SubmitIssueScreen> createState() => _SubmitIssueScreenState();
}

class _SubmitIssueScreenState extends State<SubmitIssueScreen> {
  String? _selectedIssueType;
  final TextEditingController _descriptionController = TextEditingController();

  // --- Image Picker Additions ---
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _issueTypes = [
    'App Bug',
    'Payment Issue',
    'Account Problem',
    'Pickup Dispute',
    'Other',
  ];

  // Logic to pick image based on source
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showFeedback("Error picking image: $e", Colors.red);
    }
  }

  // Selection Dialog (BottomSheet)
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_selectedIssueType == null) {
      _showFeedback("Please select an issue type", Colors.orange);
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showFeedback("Please provide a description of the issue", Colors.orange);
      return;
    }

    _showFeedback("Issue reported! We will get back to you soon.", Colors.green);
    Future.delayed(const Duration(seconds: 2), () => Navigator.pop(context));
  }

  void _showFeedback(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: Column(
        children: [
          _buildHeader(context, "Submit Issue"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Report a problem and we'll look into it"),
                  const SizedBox(height: 20),
                  const Text("Issue Type", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedIssueType,
                        hint: const Text("Select issue type"),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _issueTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedIssueType = newValue;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text("Describe the Issue", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Tell us what happened in detail...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Preview Widget
                  if (_imageFile != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: FileImage(_imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 12,
                          child: Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                        onPressed: () => setState(() => _imageFile = null),
                      ),
                    ),

                  _actionButton(
                    _imageFile == null ? "Attach Screenshot" : "Change Screenshot", 
                    const Color(0xFFC5CAE9), 
                    Colors.blue, 
                    () => _showImageSourceActionSheet(context), // Calling selection dialog
                  ),
                  const SizedBox(height: 20),
                  _actionButton("Submit Issue", Colors.green, Colors.white, _handleSubmit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color bg, Color textCol, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 2,
        ),
        child: Text(text, style: TextStyle(color: textCol, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 25),
    decoration: const BoxDecoration(
      color: Color(0xFFDFF6DD),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
    ),
    child: Row(
      children: [
        IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF2E7D32), size: 30), onPressed: () => Navigator.pop(context)),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 24)),
      ],
    ),
  );
}
