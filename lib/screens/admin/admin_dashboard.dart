import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'admin_residents.dart';
import 'admin_haulers.dart';
import 'admin_login.dart';
import 'admin_transactions.dart';
import 'admin_reports.dart'; 
import 'admin_auditlog.dart';
import 'admin_ecopoints.dart';
import 'admin_settings.dart';
import 'admin_profile.dart';

// Change to StatefulWidget so we can use setState for the chart toggle
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool showPickups = true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color bgLight = const Color(0xFFF8FAF9);
  final Color textDark = const Color(0xFF2C3E50);

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.toLowerCase();
      
      // Automatic navigation based on keywords
      if (_searchQuery.contains("Residents") && _selectedIndex != 1) {
        _selectedIndex = 1;
      } else if (_searchQuery.contains("Haulers") && _selectedIndex != 2) {
        _selectedIndex = 2;
      } else if ((_searchQuery.contains("dash") || _searchQuery.isEmpty) && _selectedIndex != 0) {
        // Optional: return to dashboard if cleared
      }
    });
  }

@override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: Row(
        children: [
          // --- SIDEBAR ---
          _buildSidebar(),

          // --- MAIN CONTENT ---
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    // Call the function here to resolve the "isn't referenced" error
                    child: _buildMainContent(), 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildMainContent() {
  switch (_selectedIndex) {
    case 0:
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          _buildStatGrid(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildActiveUsers()),
              const SizedBox(width: 24),
              Expanded(flex: 1, child: _buildRecentActivity()),
            ],
          ),
          const SizedBox(height: 24),
          _buildOverviewCard(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildWasteDistributionCard()),
              const SizedBox(width: 24),
              Expanded(child: _buildEcoPointsActivityCard()),
            ],
          ),
        ],
      )));
    case 1:
      return const AdminResidents();
    case 2:
      return AdminHaulers(searchQuery: _searchQuery);
    case 3:
      return const AdminTransactions();
    case 4:
      return const AdminReports();
    case 5:
      return const AdminAuditLog();
    case 6:
      return const AdminEcoPoints();
    case 7:
      return const AdminSettings();
    case 8:
      return const AdminProfileScreen();
    default:
      return Center(child: Text("Screen for index $_selectedIndex coming soon!"));
  }
}

  // --- COMPONENT WIDGETS ---

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(Icons.recycling, color: primaryGreen, size: 30),
                const SizedBox(width: 10),
                const Text("Waste2Wage", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF2ECC71))),
              ],
            ),
          ),
          _sidebarItem(Icons.dashboard, "Dashboard", isActive: _selectedIndex == 0, index: 0),
          _sidebarItem(Icons.people_outline, "Residents", isActive: _selectedIndex == 1, index: 1),
          _sidebarItem(Icons.local_shipping_outlined, "Haulers", isActive: _selectedIndex == 2, index: 2),
          _sidebarItem(Icons.receipt_long_outlined, "Transactions", isActive: _selectedIndex == 3, index: 3),
          _sidebarItem(Icons.bar_chart_outlined, "Reports", isActive: _selectedIndex == 4, index: 4),
          _sidebarItem(Icons.history_toggle_off, "Audit Log", isActive: _selectedIndex == 5, index: 5),
          _sidebarItem(Icons.eco_outlined, "Eco-Points", isActive: _selectedIndex == 6, index: 6),
          _sidebarItem(Icons.settings_outlined, "Settings", isActive: _selectedIndex == 7, index: 7),
        ],
      ),
    );
  }

// Add "required int index" to the parameters
Widget _sidebarItem(IconData icon, String title, {bool isActive = false, required int index}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: isActive ? primaryGreen.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      leading: Icon(icon, color: isActive ? primaryGreen : Colors.grey),
      title: Text(
        title, 
        style: TextStyle(
          color: isActive ? primaryGreen : Colors.grey[700], 
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal
        )
      ),
      dense: true,
      // Update the state when tapped
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    ),
  );
}

Widget _buildHeader() {
  return Container(
    height: 70,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: Colors.white, 
      border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController, // ADD THIS
              onChanged: _onSearchChanged, // FIXED: Use the defined function for navigation logic
              decoration: InputDecoration(
                hintText: "Search Residents, Haulers...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        
// --- NOTIFICATION POPUP ---
MenuAnchor(
  style: MenuStyle(
    backgroundColor: WidgetStateProperty.all(Colors.white),
    elevation: WidgetStateProperty.all(15),
    shadowColor: WidgetStateProperty.all(Colors.black26),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    padding: WidgetStateProperty.all(EdgeInsets.zero),
  ),
  builder: (context, controller, child) {
    return IconButton(
      onPressed: () => controller.isOpen ? controller.close() : controller.open(),
      icon: Badge(
        label: const Text('3', style: TextStyle(fontSize: 10)),
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.notifications_none_rounded, 
          color: controller.isOpen ? primaryGreen : Colors.grey[600]),
      ),
    );
  },
  menuChildren: [
    _buildPopupHeader("Notifications", trailingAction: "Mark all as read"),
    const Divider(height: 1),
    _buildNotificationItem("New Hauler Registration", "Antonio Cruz submitted verification documents", "2 mins ago", isUnread: true),
    _buildNotificationItem("Dispute Filed", "Maria Santos filed a dispute for SVC-2025-0145", "1 hour ago", isUnread: true),
    _buildNotificationItem("System Alert", "Database backup completed successfully", "5 hours ago"),
    const Divider(height: 1),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: TextButton(
          onPressed: () {},
          child: Text("View all notifications", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ),
      ),
    )
  ],
),

const SizedBox(width: 16),

// --- ADMIN USER POPUP ---
MenuAnchor(
  style: MenuStyle(
    backgroundColor: WidgetStateProperty.all(Colors.white),
    elevation: WidgetStateProperty.all(15),
    shadowColor: WidgetStateProperty.all(Colors.black26),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  ),
  builder: (context, controller, child) {
    return InkWell(
      onTap: () => controller.isOpen ? controller.close() : controller.open(),
      borderRadius: BorderRadius.circular(30), // Circular hover effect
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: controller.isOpen ? primaryGreen : Colors.grey[200]!),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: primaryGreen.withOpacity(0.1), 
              radius: 14, 
              child: Icon(Icons.person_rounded, color: primaryGreen, size: 18)
            ),
            const SizedBox(width: 8),
            Text("Admin User", 
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: controller.isOpen ? primaryGreen : textDark,
              )
            ),
            Icon(Icons.keyboard_arrow_down_rounded, 
              size: 18,
              color: controller.isOpen ? primaryGreen : Colors.grey),
          ],
        ),
      ),
    );
  },
  menuChildren: [
    Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Logged in as", style: TextStyle(color: Colors.grey, fontSize: 11)),
          Text("admin@waste2wage.com", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textDark)),
        ],
      ),
    ),
    const Divider(height: 1),
      _buildPopupItem(
        Icons.person_outline_rounded, 
        "My Profile",
        onTap: () {
          setState(() {
            _selectedIndex = 8; // Switch to the Profile index
          });
        },
      ),
    // Inside _buildHeader() -> MenuAnchor -> menuChildren:
        const Divider(height: 1),
        _buildPopupItem(
          Icons.logout_rounded, 
          "Sign out", 
          isDestructive: true,
          onTap: () {
            // This clears the navigation stack and goes back to Login
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              (route) => false,
            );
          },
        ),
          ],
        ),
      ]
    ),
  );
}

Widget _buildPopupHeader(String title, {String? trailingAction, VoidCallback? onActionPressed}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
        if (trailingAction != null)
          InkWell(
            onTap: onActionPressed,
            child: Text(
              trailingAction,
              style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    ),
  );
}

Widget _buildPopupItem(IconData icon, String label, {bool isDestructive = false, VoidCallback? onTap}) {
  return MenuItemButton(
    onPressed: onTap ?? () {}, // Use the callback here
    leadingIcon: Icon(icon, size: 18, color: isDestructive ? Colors.redAccent : Colors.grey[700]),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(label, 
        style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.grey[800], fontSize: 14)),
    ),
  );
}

Widget _buildNotificationItem(String title, String subtitle, String time, {bool isUnread = false}) {
  return MenuItemButton(
    onPressed: () {},
    child: Container(
      width: 320, // Slightly wider for better readability
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Indicator
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              Icons.circle,
              size: 8,
              color: isUnread ? primaryGreen : Colors.transparent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[400], fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text("Welcome back! Here's what's happening with Waste2Wage today.",style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      // Added SingleChildScrollView to handle the additional card without overflow
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // NEW: Sustainability Fund Card
            _statCard("Sustainability Fund (PHP)", "₱3,741.00", "15% per booking", Icons.account_balance_wallet_outlined, Colors.purple),
            _statCard("Total Residents", "1,247", "+12% from last month", Icons.people, Colors.green),
            _statCard("Verified Haulers", "89", "+5 this week", Icons.local_shipping, Colors.blue),
            _statCard("Pending Disputes", "12", "3 urgent", Icons.gavel, Colors.orange),
            _statCard("Eco-Points Distributed", "458,750", "+8,500 today", Icons.eco, Colors.teal),
          ],
        ),
      );
    });
  }

  Widget _buildActiveUsers() {
    return _contentBlock(
      title: "Active Users",
      child: Column(
        children: [
          _userTile("Maria Santos", "123 Mabini St, Makati City"),
          _userTile("Juan Dela Cruz", "456 Rizal Ave, Quezon City"),
          _userTile("Ana Reyes", "789 Bonifacio Dr, Taguig City"),
        ],
      ),
    );
  }

Widget _userTile(String name, String address) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person, size: 20)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(address),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
        child: const Text("Resident", style: TextStyle(color: Colors.green, fontSize: 12)),
      ),
      onTap: () => _showUserProfile(context, name, address), // Trigger the popup
    );
  } 

  void _showUserProfile(BuildContext context, String name, String address) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.green, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Profile Avatar Section
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, size: 60, color: Color(0xFF2ECC71)),
                ),
              ),
              const SizedBox(height: 30),

              // Info Table Section
              _buildPopupRow("Email", "maria.santos@email.com"),
              _buildPopupRow("Phone", "+63 917 123 4567"),
              _buildPopupRow("Address", address),
              _buildPopupRow("Eco-Points", "1,250", isGreen: true),
              _buildPopupRow("Completed Pickups", "45"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isGreen ? const Color(0xFF2ECC71) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return _contentBlock(
      title: "Recent Activity",
      child: Column(
        children: [
          _activityTile("Roberto Mendoza", "completed a waste pickup", Icons.inventory_2_outlined, Colors.green),
          _activityTile("Antonio Cruz", "registered as a new hauler", Icons.person_add_outlined, Colors.blue),
          _activityTile("Maria Santos", "filed a dispute for service SVC-2025-0145", Icons.warning_amber_rounded, Colors.orange),
        ],
      ),
    );
  }

Widget _activityTile(String user, String action, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: "$user ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: action),
          ],
        ),
      ),
      subtitle: const Text("1/30/2025"),
      onTap: () => _showActivityDetails(context, user, action, icon, color), // Trigger popup
    );
  }

  void _showActivityDetails(BuildContext context, String user, String action, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title and Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Activity Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.green, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // User Info Row with Icon and Badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(57, 245, 245, 245),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Text("Pickup", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Detail Rows
              _buildPopupRow("Activity ID", "ACT001"),
              _buildPopupRow("User ID", "H001"),
              _buildPopupRow("Description", action),
              _buildPopupRow("Timestamp", "1/30/2025, 4:45:00 PM"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, String sub, IconData icon, Color color) {
    return Container(
      width: 240, // Set a fixed width to support the horizontal layout
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: const Color.fromARGB(65, 158, 158, 158)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Added Expanded and maxLines to handle the longer "Sustainability Fund" title
              Expanded(
                child: Text(
                  title, 
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color.withOpacity(0.5), size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _contentBlock({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

Widget _buildOverviewCard() {
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
          const Text(
            "Pickups & Revenue Overview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Toggle Buttons Container
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toggleBtn("Pickups", showPickups),
                _toggleBtn("Revenue", !showPickups),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Responsive Chart Area
          SizedBox(
            height: 350,
            child: showPickups ? _buildBarChart() : _buildLineChart(),
          ),
        ],
      ),
    );
  }

Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 180,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 45, // Matches grid lines in image
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: _getTitlesData(),
        barGroups: [
          _makeGroup(0, 120),
          _makeGroup(1, 132),
          _makeGroup(2, 145),
          _makeGroup(3, 128),
          _makeGroup(4, 155),
          _makeGroup(5, 168),
          _makeGroup(6, 142),
        ],
      ),
    );
  }

Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 6500, // Matches revenue intervals in image
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: _getTitlesData(isRevenue: true),
        minY: 0,
        maxY: 26000,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 18000),
              FlSpot(1, 19800),
              FlSpot(2, 21500),
              FlSpot(3, 19000),
              FlSpot(4, 23500),
              FlSpot(5, 25500),
              FlSpot(6, 21000),
            ],
            isCurved: true, // Curved line styling
            color: primaryGreen,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(radius: 4, color: primaryGreen, strokeWidth: 0),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

BarChartGroupData _makeGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: primaryGreen,
          width: 100, // Matches wide bar style in image
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

FlTitlesData _getTitlesData({bool isRevenue = false}) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => Text(
            value.toInt().toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const days = ['Jan 25', 'Jan 26', 'Jan 27', 'Jan 28', 'Jan 29', 'Jan 30', 'Jan 31'];
            if (value.toInt() < 0 || value.toInt() >= days.length) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(days[value.toInt()], style: const TextStyle(color: Colors.grey, fontSize: 11)),
            );
          },
        ),
      ),
    );
  }

Widget _toggleBtn(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => showPickups = (label == "Pickups")),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: primaryGreen) : null,
          boxShadow: isSelected 
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] 
            : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryGreen : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

Widget _buildWasteDistributionCard() {
    return _contentBlock(
      title: "Waste Distribution",
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 5,
                centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(color: const Color(0xFF27AE60), value: 45, radius: 20, showTitle: false),
                  PieChartSectionData(color: const Color(0xFF2ECC71), value: 30, radius: 20, showTitle: false),
                  PieChartSectionData(color: const Color(0xFFF1C40F), value: 20, radius: 20, showTitle: false),
                  PieChartSectionData(color: const Color(0xFFE74C3C), value: 5, radius: 20, showTitle: false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _chartLegend(const Color(0xFF27AE60), "Recyclable (45%)"),
              _chartLegend(const Color(0xFF2ECC71), "Organic (30%)"),
              _chartLegend(const Color(0xFFF1C40F), "General (20%)"),
              _chartLegend(const Color(0xFFE74C3C), "Hazardous (5%)"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildEcoPointsActivityCard() {
    return _contentBlock(
      title: "Eco-Points Activity",
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: 12000,
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 3000),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Jan 25', 'Jan 26', 'Jan 27', 'Jan 28', 'Jan 29', 'Jan 30', 'Jan 31'];
                        return Text(days[value.toInt()], style: const TextStyle(fontSize: 10, color: Colors.grey));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: [
                  _groupedBar(0, 8500, 3200),
                  _groupedBar(1, 9200, 4100),
                  _groupedBar(2, 7800, 2800),
                  _groupedBar(3, 10500, 5200),
                  _groupedBar(4, 11200, 4800),
                  _groupedBar(5, 9800, 3900),
                  _groupedBar(6, 8900, 4500),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _chartLegend(const Color(0xFF27AE60), "Earned"),
              const SizedBox(width: 20),
              _chartLegend(const Color(0xFFF39C12), "Redeemed"),
            ],
          )
        ],
      ),
    );
  }

  // --- HELPERS ---

  Widget _chartLegend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  BarChartGroupData _groupedBar(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: const Color(0xFF27AE60), width: 12, borderRadius: BorderRadius.circular(2)),
        BarChartRodData(toY: y2, color: const Color(0xFFF39C12), width: 12, borderRadius: BorderRadius.circular(2)),
      ],
    );
  }

}