import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

class AdminTransactions extends StatefulWidget {
  const AdminTransactions({super.key});

  @override
  State<AdminTransactions> createState() => _AdminTransactionsState();
}

class _AdminTransactionsState extends State<AdminTransactions> {
  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color lightGreenBg = const Color(0xFFE8F5E9);
  final Color borderColor = const Color(0xFFE5E7EB);

  // State variables for filtering
  String selectedStatus = "All Status";
  String selectedType = "All Types";
  String searchQuery = "";
  DateTime? selectedDate; // Added for Date pop-up functionality

  // The master data list
  final List<Map<String, String>> allTransactions = [
    {"id": "TXN001", "res": "Maria Santos", "haul": "Roberto Mendoza", "type": "Pickup", "pay": "Gcash", "amt": "₱150", "status": "Completed", "date": "1/30/2025"},
    {"id": "TXN002", "res": "Ana Reyes", "haul": "Miguel Torres", "type": "Pickup", "pay": "Wallet", "amt": "₱200", "status": "Completed", "date": "1/30/2025"},
    {"id": "TXN003", "res": "Juan Dela Cruz", "haul": "Carlos Villanueva", "type": "Eco Points-Redemption", "pay": "Eco-Points", "amt": "₱500", "status": "Pending", "date": "1/29/2025"},
    {"id": "TXN004", "res": "Carmen Lim", "haul": "Roberto Mendoza", "type": "Pickup", "pay": "Cash", "amt": "₱175", "status": "Completed", "date": "1/29/2025"},
    {"id": "TXN005", "res": "Pedro Garcia", "haul": "Miguel Torres", "type": "Penalty", "pay": "Wallet", "amt": "-₱50", "status": "Completed", "date": "1/28/2025"},
  ];

  // Logic to filter the list dynamically
  List<Map<String, String>> get filteredTransactions {
    return allTransactions.where((txn) {
      final bool matchesStatus = selectedStatus == "All Status" || txn['status'] == selectedStatus;
      
      final String searchType = selectedType.split('-')[0].toLowerCase();
      final bool matchesType = selectedType == "All Types" || 
                               txn['type']!.toLowerCase().contains(searchType);
      
      final String query = searchQuery.toLowerCase().trim();
      final bool matchesSearch = query.isEmpty || 
          txn['id']!.toLowerCase().contains(query) ||
          txn['res']!.toLowerCase().contains(query) ||
          txn['haul']!.toLowerCase().contains(query);

      // Simple date matching (String based for this example)
      bool matchesDate = true;
      if (selectedDate != null) {
        String formattedSelected = DateFormat('M/d/yyyy').format(selectedDate!);
        matchesDate = txn['date'] == formattedSelected;
      }

      return matchesStatus && matchesType && matchesSearch && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> transactions = filteredTransactions;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Transactions", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("View and manage all financial transactions", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 24),

            // --- FILTER BAR ---
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: "Search by ID, Residents, Haulers...",
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown(
                  context, 
                  selectedStatus, 
                  ["All Status", "Completed", "Pending", "Failed", "Refunded"],
                  (val) => setState(() => selectedStatus = val)
                ),
                const SizedBox(width: 8),
                _buildFilterDropdown(
                  context, 
                  selectedType, 
                  ["All Types", "Pickup", "Eco-Points", "Penalty", "Bonus"],
                  (val) => setState(() => selectedType = val)
                ),
                const SizedBox(width: 8),
                _buildDateRangeButton(), // Updated with pop-up
              ],
            ),
            const SizedBox(height: 20),

            // --- DATA TABLE --- (Unchanged per instructions)
            Container(
              width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),              
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: SizedBox(width: 80, child: Text("Transaction ID", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)))),
                            DataColumn(label: SizedBox(width: 120, child: Text("Resident", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)))),
                            DataColumn(label: Text("Hauler", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            DataColumn(label: Text("Payment", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                          ],
                          rows: transactions.map((user) => DataRow(
                            onSelectChanged: (_) => _showTransactionDetails(
                              context, user['id']!, user['res']!, user['haul']!, user['type']!, user['pay']!, user['amt']!, user['status']!, user['date']!
                            ),
                            cells: [
                              DataCell(SizedBox(width: 80, child: Text(user['id']!, style: const TextStyle(fontWeight: FontWeight.w500)))),
                              DataCell(SizedBox(width: 120, child: Text(user['res']!, style: const TextStyle(fontWeight: FontWeight.w500)))),
                              DataCell(Text(user['haul']!)),
                              DataCell(_buildTypeChip(user['type']!)),
                              DataCell(Text(user['pay']!)),
                              DataCell(Text(user['amt']!, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold))),
                              DataCell(_buildStatusChip(user['status']!)),
                              DataCell(Text(user['date']!)),
                            ]
                          )).toList(),
                        ),
                      ),
                    );
                  }
                ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildDateRangeButton() {
    return PopupMenuButton<void>(
      offset: const Offset(0, 10),
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      constraints: const BoxConstraints(maxWidth: 250),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          enabled: false, // Prevents closing when clicking inside the calendar
          child: StatefulBuilder(
            builder: (context, menuSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: primaryGreen,
                        onPrimary: Colors.white,
                        onSurface: Colors.black87,
                      ),
                    ),
                    child: SizedBox(
                      height: 300,
                      width: 230,
                      child: CalendarDatePicker(
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        onDateChanged: (date) {
                          setState(() => selectedDate = date);
                          Navigator.pop(context); // Close dropdown after selection
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() => selectedDate = null);
                            Navigator.pop(context);
                          },
                          child: const Text("Clear", style: TextStyle(color: Colors.blue, fontSize: 13)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() => selectedDate = DateTime.now());
                            Navigator.pop(context);
                          },
                          child: const Text("Today", style: TextStyle(color: Colors.blue, fontSize: 13)),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedDate == null 
                ? "dd/mm/yyyy" 
                : "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}",
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  } 

  // Existing helpers (Dropdowns, Chips, Details) remain unchanged
  Widget _buildFilterDropdown(BuildContext context, String currentLabel, List<String> options, Function(String) onSelect) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 10),
      position: PopupMenuPosition.under,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: onSelect,
      itemBuilder: (BuildContext context) {
        return options.map((String option) {
          bool isSelected = option == currentLabel;
          return PopupMenuItem<String>(
            value: option,
            height: 40,
            child: Container(
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? lightGreenBg : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  if (isSelected) Icon(Icons.check, size: 16, color: primaryGreen) else const SizedBox(width: 16),
                  const SizedBox(width: 8),
                  Text(option, style: TextStyle(fontSize: 13, color: isSelected ? primaryGreen : Colors.black87, fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal)),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentLabel, style: const TextStyle(fontSize: 13)),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, String id, String res, String haul, String type, String pay, String amt, String status, String date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Transaction Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.green), padding: EdgeInsets.zero, constraints: const BoxConstraints())
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: const Color.fromARGB(104, 249, 250, 251), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      const Text("Amount", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(amt, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildDetailRow("Transaction ID", id),
                _buildDetailRow("Reference", "REF-2025-001234"),
                _buildDetailRowWidget("Type", _buildTypeChip(type)),
                _buildDetailRowWidget("Status", _buildStatusChip(status)),
                _buildDetailRow("Payment Method", pay),
                const Divider(height: 32),
                _buildDetailRow("Resident", res, isBold: true),
                _buildDetailRow("Hauler", haul, isBold: true),
                const Divider(height: 32),
                _buildDetailRow("Date", date),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDetailRowWidget(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          child,
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    bool isCompleted = status == "Completed";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isCompleted ? Colors.green[200]! : Colors.orange[200]!),
      ),
      child: Text(status, style: TextStyle(color: isCompleted ? Colors.green[700] : Colors.orange[700], fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTypeChip(String type) {
    Color color = Colors.green;
    if (type.contains("Redemption")) color = Colors.purple;
    if (type == "Penalty") color = Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(type, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}