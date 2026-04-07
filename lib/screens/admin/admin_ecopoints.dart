import 'package:flutter/material.dart';

// Changed to StatefulWidget to allow for search and data updates
class AdminEcoPoints extends StatefulWidget {
  const AdminEcoPoints({super.key});

  @override
  State<AdminEcoPoints> createState() => _AdminEcoPointsState();
}

class _AdminEcoPointsState extends State<AdminEcoPoints> {
  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color textDark = const Color(0xFF2C3E50);

  // Controllers for inputs
  final TextEditingController _residentSearchController = TextEditingController();
  final TextEditingController _haulerSearchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  // Mock Data for filtering functionality
  final List<Map<String, String>> _residents = [
    {"name": "Maria Santos", "email": "maria.santos@email.com", "points": "1,250"},
    {"name": "Juan Dela Cruz", "email": "juan.delacruz@email.com", "points": "890"},
    {"name": "Ana Reyes", "email": "ana.reyes@email.com", "points": "2,100"},
    {"name": "Pedro Garcia", "email": "pedro.garcia@email.com", "points": "150"},
    {"name": "Carmen Lim", "email": "carmen.lim@email.com", "points": "3,200"},
  ];

  final List<Map<String, dynamic>> _haulers = [
    {
      "name": "Roberto Mendoza",
      "route": "Makati - BGC Route",
      "points": "5,600",
      "eligible": true
    },
    {
      "name": "Miguel Torres",
      "route": "Manila Central",
      "points": "4,200",
      "eligible": false
    },
    {
      "name": "Carlos Villanueva",
      "route": "Cavite Express",
      "points": "7,800",
      "eligible": true
    },
  ];

  final List<Map<String, dynamic>> _logs = [
    {"name": "Maria Santos", "desc": "Completed pickup", "points": "+50", "date": "2025-01-30", "isAdd": true},
    {"name": "Ana Reyes", "desc": "Redeemed voucher", "points": "-200", "date": "2025-01-29", "isAdd": false},
  ];

  @override
  void dispose() {
    _residentSearchController.dispose();
    _haulerSearchController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
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
            // --- PAGE TITLE ---
            Row(
              children: [
                Icon(Icons.eco_outlined, color: primaryGreen, size: 28),
                const SizedBox(width: 10),
                Text(
                  "Eco-Points Management",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Manage eco-points for residents and haulers",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),

            // --- STAT CARDS ---
            Row(
              children: [
                _buildStatCard("Total Points in Circulation", "458,750", null),
                const SizedBox(width: 16),
                _buildStatCard("Points Distributed Today", "+ 8,500", primaryGreen),
                const SizedBox(width: 16),
                _buildStatCard("Points Redeemed Today", "- 3,200", Colors.orange),
              ],
            ),
            const SizedBox(height: 24),

            // --- ACCORDION SECTIONS ---
            _buildAccordion(
              title: "Resident Eco-Points",
              icon: Icons.people_outline,
              child: _buildResidentTable(context),
            ),
            const SizedBox(height: 12),
            _buildAccordion(
              title: "Hauler Eco-Points",
              icon: Icons.local_shipping_outlined,
              child: _buildHaulerTable(),
            ),
            const SizedBox(height: 12),
            _buildAccordion(
              title: "Eco-Point Logs",
              icon: Icons.history,
              child: _buildLogsList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- POP-UP DIALOG METHOD ---

  void _addLogEntry(String name, String desc, String amount, bool isAdd) {
  final String date = DateTime.now().toString().split(' ')[0]; // Gets YYYY-MM-DD
  _logs.insert(0, {
    "name": name,
    "desc": desc,
    "points": "${isAdd ? '+' : '-'}$amount",
    "date": date,
    "isAdd": isAdd,
  });
}

  void _showPointDialog(BuildContext context, String name, String balance, bool isAdding) {
    final Color themeColor = isAdding ? primaryGreen : Colors.redAccent;
    final String actionText = isAdding ? "Add" : "Deduct";
    
    // Clear controllers for fresh input
    _amountController.clear();
    _reasonController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(isAdding ? Icons.add : Icons.remove, color: themeColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "$actionText Eco-Points", 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const Divider(height: 32),
              const Text("User", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 20),
              const Text("Current Balance", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                "$balance points", 
                style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 22)
              ),
              const SizedBox(height: 24),
              const Text("Amount", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter points amount",
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryGreen, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Reason", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter reason for adjustment...",
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_amountController.text.isNotEmpty) {
                        setState(() {
                          int index = _residents.indexWhere((r) => r['name'] == name);
                          if (index != -1) {
                            _residents[index]['points'] = _calculateNewPoints(
                              _residents[index]['points']!, 
                              _amountController.text, 
                              isAdding
                            );
                            _addLogEntry(
                              name, 
                              _reasonController.text.isEmpty ? "Manual Adjustment" : _reasonController.text, 
                              _amountController.text, 
                              isAdding
                            );
                          }
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Points ${isAdding ? 'added' : 'deducted'} successfully for $name"))
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("$actionText Points", style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- COMPONENT WIDGETS ---

  Widget _buildStatCard(String title, String value, Color? valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: valueColor ?? textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion({required String title, required IconData icon, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: textDark, size: 22),
          title: Text(
            title,
            style: TextStyle(color: textDark, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: child,
            )
          ],
        ),
      ),
    );
  }

  // --- CONTENT BUILDERS ---

  Widget _buildSearchBar(String hint, TextEditingController controller, VoidCallback onChanged) {
    return SizedBox(
      width: 500,
      height: 35,
      child: TextField(
        controller: controller,
        onChanged: (value) => onChanged(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
        ),
      ),
    );
  }

  Widget _buildResidentTable(BuildContext context) {
    // Filter logic based on the search controller
    final filteredResidents = _residents.where((res) {
      return res['name']!.toLowerCase().contains(_residentSearchController.text.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar("Search residents...", _residentSearchController, () => setState(() {})),
        const SizedBox(height: 16),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1),
            3: IntrinsicColumnWidth(),
          },
          children: [
            _tableHeader(["Name", "Email", "Eco-Points", "Actions"]),
            ...filteredResidents.map((res) => _residentRow(context, res['name']!, res['email']!, res['points']!)),
          ],
        ),
      ],
    );
  }

  Widget _buildHaulerTable() {
    // Filter the hauler list based on the search controller text
    final filteredHaulers = _haulers.where((hauler) {
      final name = hauler['name'].toString().toLowerCase();
      final route = hauler['route'].toString().toLowerCase();
      final query = _haulerSearchController.text.toLowerCase();
      return name.contains(query) || route.contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pass the controller and a refresh callback
        _buildSearchBar(
          "Search haulers by name or route...", 
          _haulerSearchController, 
          () => setState(() {})
        ),
        const SizedBox(height: 16),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(2),
            4: IntrinsicColumnWidth(),
          },
          children: [
            _tableHeader(["Name", "Route", "Eco-Points", "Recommendation", "Actions"]),
            // Generate rows from the filtered list
            ...filteredHaulers.map((hauler) => _haulerRow(
                  hauler['name'],
                  hauler['route'],
                  hauler['points'],
                  hauler['eligible'],
                )),
          ],
        ),
        if (filteredHaulers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(child: Text("No haulers found", style: TextStyle(color: Colors.grey[400]))),
          ),
      ],
    );
  }

  TableRow _tableHeader(List<String> labels) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[50]),
      children: labels.map((label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
      )).toList(),
    );
  }

  TableRow _residentRow(BuildContext context, String name, String email, String points) {
    return TableRow(
      children: [
        _cellText(name),
        _cellText(email),
        _cellText(points, color: primaryGreen),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionBtn(Icons.add, "Add", () => _showPointDialog(context, name, points, true)),
              const SizedBox(width: 8),
              _actionBtn(Icons.remove, "Deduct", () => _showPointDialog(context, name, points, false)),
            ],
          ),
        ),
      ],
    );
  }

  TableRow _haulerRow(String name, String route, String points, bool eligible) {
  return TableRow(
    children: [
      _cellText(name),
      _cellText(route),
      _cellText(points, color: primaryGreen),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: eligible
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Eligible for Bonus",
                  style: TextStyle(
                      color: primaryGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              )
            : const SizedBox.shrink(),
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
        onPressed: !eligible ? null : () {
          setState(() {
            int index = _haulers.indexWhere((h) => h['name'] == name);
            if (index != -1) {
              _haulers[index]['points'] = _calculateNewPoints(_haulers[index]['points']!, "500", true);
              _haulers[index]['eligible'] = false;

              // ADDED: Create log entry for Hauler
              _addLogEntry(name, "Route Bonus: $route", "500", true);
            }
          });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Bonus points issued to $name. Status updated."))
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text("Apply Reward", style: TextStyle(fontSize: 12)),
        ),
      ),
    ],
  );
}

  Widget _cellText(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(text, style: TextStyle(color: color ?? textDark, fontSize: 13)),
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      style: OutlinedButton.styleFrom(
        foregroundColor: textDark,
        side: BorderSide(color: Colors.grey[300]!),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildLogsList() {
    if (_logs.isEmpty) {
      return const Padding(padding: EdgeInsets.all(20), child: Text("No logs available"));
    }
    return Column(
      children: _logs.map((log) {
        return Column(
          children: [
            _logTile(log['name'], log['desc'], log['points'], log['date'], log['isAdd']),
            const Divider(height: 1),
          ],
        );
      }).toList(),
    );
  }

  Widget _logTile(String name, String desc, String points, String date, bool isAdd) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isAdd ? Colors.green[50] : Colors.red[50],
            child: Icon(Icons.eco, size: 18, color: isAdd ? primaryGreen : Colors.redAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(points, style: TextStyle(color: isAdd ? primaryGreen : Colors.redAccent, fontWeight: FontWeight.bold)),
              Text(date, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  // Helper to handle string formatting and math
  String _calculateNewPoints(String currentPoints, String changeAmount, bool isAdding) {
    // Remove commas to parse as integer
    int current = int.parse(currentPoints.replaceAll(',', ''));
    int change = int.tryParse(changeAmount) ?? 0;
    
    int result = isAdding ? current + change : current - change;
    if (result < 0) result = 0; // Prevent negative points

    // Return formatted string with commas
    return result.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}