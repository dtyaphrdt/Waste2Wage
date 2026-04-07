import 'package:flutter/material.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  int _currentTab = 0;
  String selectedStatus = "Investigating";
  // Track role for the Add Admin popup specifically
  String _tempRole = "Select role";

  // --- NEW STATE VARIABLES ---
  bool isMaintenanceMode = false;
  
  // Dynamic list for Admin Management
  List<Map<String, dynamic>> admins = [
    {"name": "John Admin", "email": "john@waste2wage.com", "role": "Super Admin", "color": Colors.green},
    {"name": "Sarah Manager", "email": "sarah@waste2wage.com", "role": "Admin", "color": Colors.blue},
    {"name": "Mike Support", "email": "mike@waste2wage.com", "role": "Moderator", "color": Colors.grey},
  ];

  // Controllers for Service Config
  final TextEditingController _pickupFeeController = TextEditingController(text: "20");
  final TextEditingController _ecoPointsController = TextEditingController(text: "50");
  final TextEditingController _bonusPointsController = TextEditingController(text: "15");
  final TextEditingController _referralPointsController = TextEditingController(text: "100");
  final TextEditingController _penaltyController = TextEditingController(text: "10");

  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color textDark = const Color(0xFF2C3E50);
  final Color lightGreenBg = const Color(0xFFE8F5E9);

  @override
  void dispose() {
    _pickupFeeController.dispose();
    _ecoPointsController.dispose();
    _bonusPointsController.dispose();
    _referralPointsController.dispose();
    _penaltyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleSection(),
            const SizedBox(height: 15),
            _buildTabNavigation(),
            const SizedBox(height: 15),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  // Updated helper for popup menu items to be used in both Add/Edit

  PopupMenuItem<String> _buildPopupMenuItem(String value, String currentStatus) {
    bool isSelected = currentStatus == value;
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? lightGreenBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.check, size: 16, color: isSelected ? primaryGreen : Colors.transparent),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? primaryGreen : Colors.black87,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- POP-UP DIALOGS ---

  void _showAddAdminDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    _tempRole = "Select role"; // Reset role for new entry

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            titlePadding: const EdgeInsets.fromLTRB(24, 20, 15, 10),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Add New Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            content: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPopupField("Name", nameCtrl, hint: "Enter name"),
                  const SizedBox(height: 16),
                  _buildPopupField("Email", emailCtrl, hint: "Enter email"),
                  const SizedBox(height: 16),
                  const Text("Role", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Theme(
                    data: Theme.of(context).copyWith(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    child: PopupMenuButton<String>(
                      offset: const Offset(0, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      onSelected: (String value) {
                        setDialogState(() => _tempRole = value);
                      },
                      itemBuilder: (BuildContext context) => [
                        _buildPopupMenuItem("Super Admin", _tempRole),
                        _buildPopupMenuItem("Admin", _tempRole),
                        _buildPopupMenuItem("Moderator", _tempRole),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_tempRole, 
                              style: TextStyle(
                                fontSize: 16, 
                                color: _tempRole == "Select role" ? Colors.grey : Colors.black
                              )
                            ),
                            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(0, 0, 24, 20),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                ),
                child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && _tempRole != "Select role") {
                    setState(() {
                      admins.add({
                        "name": nameCtrl.text,
                        "email": emailCtrl.text,
                        "role": _tempRole,
                        "color": _tempRole == "Super Admin" ? Colors.green : (_tempRole == "Admin" ? Colors.blue : Colors.grey)
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text("Add Admin", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteAdminDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Remove Admin?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(
          "Are you sure you want to remove ${admins[index]['name']} from the admin team?\nThis action cannot be undone.",
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryGreen),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            child: Text("Cancel", style: TextStyle(color: primaryGreen)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => admins.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Remove", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPopupField(String label, TextEditingController controller, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
        ),
      ],
    );
  }

  // --- CORE UI LAYOUT ---

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Settings", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Manage admin accounts, service configuration, and system tools", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildTabNavigation() {
    return Row(
      children: [
        _tabButton(0, Icons.people_outline, "Admin Management"),
        const SizedBox(width: 8),
        _tabButton(1, Icons.settings_outlined, "Service Config"),
        const SizedBox(width: 8),
        _tabButton(2, Icons.build_outlined, "System Tools"),
      ],
    );
  }

  Widget _tabButton(int index, IconData icon, String label) {
    bool isActive = _currentTab == index;
    return InkWell(
      onTap: () => setState(() => _currentTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isActive ? textDark : Colors.grey),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: isActive ? textDark : Colors.grey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTab) {
      case 0: return _buildAdminManagement();
      case 1: return _buildServiceConfig();
      case 2: return _buildSystemTools();
      default: return Container();
    }
  }

  // --- TAB 1: ADMIN MANAGEMENT ---
  Widget _buildAdminManagement() {
    return _sectionCard(
      title: "Admin Accounts",
      subtitle: "Manage administrator access to the dashboard",
      trailing: ElevatedButton.icon(
        onPressed: () => _showAddAdminDialog(), // Updated to show dialog
        icon: const Icon(Icons.add, size: 16, color: Colors.white),
        label: const Text("Add Admin", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
          horizontalMargin: 12,
          columns: const [
            DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Email", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Role", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Last Login", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Action", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: List<DataRow>.generate(admins.length, (index) {
            final admin = admins[index];
            return _adminRow(index, admin["name"], admin["email"], admin["role"], admin["color"]);
          }),
        ),
      ),
    );
  }

  // --- TAB 2: SERVICE CONFIG ---
  Widget _buildServiceConfig() {
    return _sectionCard(
      title: "Service Configuration",
      subtitle: "Configure pickup fees, eco-points rules, and rewards",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInputField("Pickup Fee (₱)", _pickupFeeController)),
              const SizedBox(width: 20),
              Expanded(child: _buildInputField("Eco-Points per Pickup", _ecoPointsController)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInputField("Segregation Bonus Points", _bonusPointsController)),
              const SizedBox(width: 24),
              Expanded(child: _buildInputField("Referral Reward Points", _referralPointsController)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildInputField("Penalty Amount (₱)", _penaltyController)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Configuration saved.")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Save Configuration",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 3: SYSTEM TOOLS ---
  Widget _buildSystemTools() {
    return Column(
      children: [
        _sectionCard(
          title: "Maintenance Mode",
          subtitle: "When enabled, the app will show a maintenance page to all users",
          trailing: Switch(
            value: isMaintenanceMode, 
            onChanged: (v) => setState(() => isMaintenanceMode = v), 
            activeColor: primaryGreen
          ),
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),
        _buildNotificationTemplates(),
        const SizedBox(height: 24),
        _buildBackupRestore(),
      ],
    );
  }

  Widget _buildNotificationTemplates() {
    return _sectionCard(
      title: "Notification Templates",
      subtitle: "Manage notification templates for emails, push, and SMS",
      child: Column(
        children: [
          _templateTile("Welcome Email", "Email", true),
          _templateTile("Pickup Confirmation", "Push", true),
          _templateTile("Payment Receipt", "Email", true),
          _templateTile("Dispute Resolution", "Email", false),
          _templateTile("Hauler Verification", "Sms", true),
        ],
      ),
    );
  }

  Widget _buildBackupRestore() {
    return _sectionCard(
      title: "Backup & Restore",
      subtitle: "Manage database backups and system restoration",
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading Backup...")));
            },
            icon: const Icon(Icons.download_outlined, size: 18),
            label: const Text("Download Backup"),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Restoring Backup...")));
            }, 
            child: const Text("Restore from Backup")
          ),
        ],
      ),
    );
  }

  // --- HELPER UI COMPONENTS ---

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDark)),
                    Text(subtitle,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  DataRow _adminRow(int index, String name, String email, String role, Color color) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(email)),
      DataCell(Chip(
          label: Text(role, style: TextStyle(color: color, fontSize: 10)),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      )),
      DataCell(const Text("2025-01-30 16:00")),
      DataCell(Row(
        children: [
          // Changed IconButton to TextButton.icon to include "Delete Account" text
          TextButton.icon(
            onPressed: () => _showDeleteAdminDialog(index),
            label: const Text(
              "Delete Account", 
              style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500)
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      )),
    ]);
  }

  Widget _templateTile(String title, String type, bool status) {
    bool localStatus = status;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: StatefulBuilder(
        builder: (context, setLocalState) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                    child: Text(type, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  )
                ],
              ),
              Switch(
                value: localStatus, 
                onChanged: (v) => setLocalState(() => localStatus = v), 
                activeColor: primaryGreen
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[200]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[200]!)),
          ),
        ),
      ],
    );
  }
}