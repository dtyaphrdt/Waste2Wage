import 'package:flutter/material.dart';
import 'resident_home.dart';
import 'resident_edit_profile.dart';
import 'resident_change_password.dart';
import '../../screens/auth/welcome_screen.dart'; 
import 'resident_privacypolicy.dart';

class ResidentProfileScreen extends StatefulWidget {
  const ResidentProfileScreen({super.key});

  @override
  State<ResidentProfileScreen> createState() => _ResidentProfileScreenState();
}

class _ResidentProfileScreenState extends State<ResidentProfileScreen> {
  bool _notificationsEnabled = false;
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentHomeScreen()));
                  }, 
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(25),
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[300], border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))]),
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      const Text("Maria Santos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 5),
                      Text("mariasantos@gmail.com", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Row(children: [
                  Icon(Icons.settings_outlined, color: textGreen, size: 20),
                  const SizedBox(width: 8),
                  const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                ]),
                const SizedBox(height: 15),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))]),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        icon: Icons.notifications_none, 
                        title: "Push Notifications", 
                        subtitle: "Pickup reminders & updates", 
                        trailing: Switch(
                          value: _notificationsEnabled, 
                          // [FIXED] Updated Switch properties
                          activeTrackColor: textGreen, 
                          activeThumbColor: Colors.white,
                          onChanged: (val) { setState(() => _notificationsEnabled = val); }
                        )
                      ),
                      _buildDivider(),
                      _buildSettingsItem(icon: Icons.person_outline, title: "Edit Profile", subtitle: "Update your info", onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentEditProfileScreen())); }),
                      _buildDivider(),
                      _buildSettingsItem(icon: Icons.shield_outlined, title: "Privacy & Security", subtitle: "Account Settings", onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentChangePasswordScreen())); }),
                      _buildDivider(),
                      _buildSettingsItem(icon: Icons.info_outline, title: "App Information", subtitle: "Get assistance", onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen())
                          );
                        }
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity, height: 55,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => const WelcomeScreen()), 
                        (route) => false
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.white, foregroundColor: Colors.red,
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title, required String subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFE8F5E9), shape: BoxShape.circle, border: Border.all(color: const Color(0xFF388E3C).withValues(alpha: 0.2))), child: Icon(icon, color: const Color(0xFF388E3C), size: 22)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[100], indent: 70, endIndent: 20);
  }
}