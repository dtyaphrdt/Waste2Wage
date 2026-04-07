import 'package:flutter/material.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  int _activeTab = 0; // 0 for Resident, 1 for Hauler
  String selectedStatus = "All Status";
  // Added: Search Controller
  final TextEditingController _searchController = TextEditingController();

  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color textDark = const Color(0xFF2C3E50);
  final Color lightGreenBg = const Color(0xFFE8F5E9);

  // --- MOCK DATA ---
  final List<Map<String, String>> residentReports = [
    {
      "id": "RPT001",
      "reporter": "Maria Santos",
      "target": "Jose Ramos",
      "issue": "Missed Pickup",
      "status": "Investigating",
      "date": "1/29/2025"
    },
    {
      "id": "RPT003",
      "reporter": "Ana Reyes",
      "target": "Miguel Torres",
      "issue": "Rude Behavior",
      "status": "Resolved",
      "date": "1/25/2025"
    },
  ];

  final List<Map<String, String>> haulerReports = [
    {
      "id": "RPT002",
      "reporter": "Roberto Mendoza",
      "target": "Pedro Garcia",
      "issue": "Improper Segragatiion",
      "status": "Open",
      "date": "1/28/2025"
    },
  ];

  // Added: Logic to filter reports
  List<Map<String, String>> get _filteredReports {
    List<Map<String, String>> baseList = _activeTab == 0 ? residentReports : haulerReports;
    String query = _searchController.text.toLowerCase();

    return baseList.where((report) {
      bool matchesSearch = report["id"]!.toLowerCase().contains(query) ||
          report["reporter"]!.toLowerCase().contains(query) ||
          report["target"]!.toLowerCase().contains(query);

      bool matchesStatus = selectedStatus == "All Status" || report["status"] == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Modified: Using the filtered list instead of the raw list
    final currentReports = _filteredReports;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reports", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Manage reports from residents and haulers",
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      // Added: Controller and onChanged to refresh UI
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "Search reports...",
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildStatusFilter(),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildTabItem("Resident Reports", residentReports.length, 0),
                      const SizedBox(width: 12),
                      _buildTabItem("Hauler Reports", haulerReports.length, 1),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      showCheckboxColumn: false,
                      headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                      horizontalMargin: 12,
                      columns: const [
                        DataColumn(label: Text("Report ID", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Reporter", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Target", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Issue", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: currentReports.map((report) {
                        return DataRow(
                          onSelectChanged: (bool? selected) {
                            if (selected != null && selected) {
                              _showReportDetails(context, report, _activeTab == 0);
                            }
                          },
                          cells: [
                            DataCell(Text(report["id"]!, style: const TextStyle(fontWeight: FontWeight.w500))),
                            DataCell(Text(report["reporter"]!)),
                            DataCell(Text(report["target"]!)),
                            DataCell(Text(report["issue"]!)),
                            DataCell(_buildStatusBadge(report["status"]!)),
                            DataCell(Text(report["date"]!)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- POPUP DIALOG ---
  void _showReportDetails(BuildContext context, Map<String, String> report, bool isResident) {
    String localStatus = report['status']!;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.orange[400], size: 22),
                          const SizedBox(width: 8),
                          const Text("Report Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildInfoColumn("Report ID", report['id']!, isBold: true)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Status", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 6),
                            PopupMenuButton<String>(
                              offset: const Offset(0, 42),
                              elevation: 2,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.grey[200]!),
                              ),
                              child: Container(
                                height: 38,
                                width: 170,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(localStatus,
                                        style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
                                    Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[600]),
                                  ],
                                ),
                              ),
                              onSelected: (String value) {
                                // Added: Update both local and main state
                                setDialogState(() => localStatus = value);
                                setState(() => report['status'] = value);
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                _buildPopupItemInsideDialog("Open", localStatus),
                                _buildPopupItemInsideDialog("Investigating", localStatus),
                                _buildPopupItemInsideDialog("Resolved", localStatus),
                                _buildPopupItemInsideDialog("Closed", localStatus),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoColumn("Reporter", report['reporter']!, isBold: true),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(isResident ? "Resident" : "Hauler",
                                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: _buildInfoColumn("Target", report['target']!, isBold: true)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoColumn("Issue", report['issue']!, isBold: true, fontSize: 16),
                  const SizedBox(height: 20),
                  const Text("Description", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Text(
                        isResident
                            ? "Hauler did not arrive at the scheduled time."
                            : "The collection point was blocked by private vehicles.",
                        style: const TextStyle(fontSize: 13, height: 1.4)),
                  ),
                  const SizedBox(height: 20),
                  const Text("Admin Notes", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "Add your notes here...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: BorderSide(color: Colors.grey[300]!),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text("Close", style: TextStyle(fontSize: 13)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.save, size: 16), 
                        label: const Text("Update", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- HELPERS ---

  Widget _buildInfoColumn(String label, String value, {bool isBold = false, double fontSize = 14}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textDark,
        )),
      ],
    );
  }

  Widget _buildTabItem(String label, int count, int index) {
    bool isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() {
        _activeTab = index;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryGreen.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? primaryGreen.withOpacity(0.3) : Colors.transparent),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(color: isActive ? primaryGreen : Colors.grey[600], fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: isActive ? primaryGreen : Colors.grey[200], borderRadius: BorderRadius.circular(4)),
              child: Text(count.toString(), style: TextStyle(color: isActive ? Colors.white : Colors.grey[600], fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case "Investigating":
        bgColor = const Color(0xFFFFF7ED); textColor = Colors.orange; break;
      case "Resolved":
        bgColor = const Color(0xFFF0FDF4); textColor = primaryGreen; break;
      case "Open":
        bgColor = const Color(0xFFEFF6FF); textColor = Colors.blue; break;
      case "Closed":
        bgColor = Colors.grey[200]!; textColor = Colors.grey[700]!; break;
      default:
        bgColor = Colors.grey[100]!; textColor = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: textColor.withOpacity(0.2))),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selectedStatus, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[600]),
          ],
        ),
      ),
      onSelected: (String value) {
        setState(() {
          selectedStatus = value;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildPopupItem("All Status"),
        _buildPopupItem("Open"),
        _buildPopupItem("Investigating"),
        _buildPopupItem("Resolved"),
        _buildPopupItem("Closed"),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value) {
    bool isSelected = selectedStatus == value;
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

  PopupMenuItem<String> _buildPopupItemInsideDialog(String value, String currentStatus) {
    bool isSelected = currentStatus == value;
    return PopupMenuItem<String>(
      value: value,
      height: 35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? lightGreenBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.check, size: 14, color: isSelected ? primaryGreen : Colors.transparent),
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
}