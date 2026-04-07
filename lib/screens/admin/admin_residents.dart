import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminResidents extends StatefulWidget {
  final String searchQuery;
  const AdminResidents({super.key, this.searchQuery = ""});

  @override
  State<AdminResidents> createState() => _AdminResidentsState();
}

class _AdminResidentsState extends State<AdminResidents> {
  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color lightGreenBg = const Color(0xFFE8F5E9);

  String selectedStatus = "All Status";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> residents = [
    {"name": "Maria Santos", "address": "123 Mabini St, Makati City", "email": "maria.santos@email.com", "phone": "+63 917 123 4567", "points": "1,250", "pickups": 45, "status": "Active", "regDate": "1/15/2024"},
    {"name": "Juan Dela Cruz", "address": "456 Rizal Ave, Quezon City", "email": "juan.delacruz@email.com", "phone": "+63 918 234 5678", "points": "890", "pickups": 32, "status": "Active", "regDate": "2/20/2024"},
    {"name": "Ana Reyes", "address": "789 Bonifacio Dr, Taguig City", "email": "ana.reyes@email.com", "phone": "+63 919 345 6789", "points": "2,100", "pickups": 78, "status": "Active", "regDate": "11/10/2023"},
    {"name": "Pedro Garcia", "address": "321 Luna St, Manila", "email": "pedro.garcia@email.com", "phone": "+63 920 456 7890", "points": "150", "pickups": 5, "status": "Suspended", "regDate": "6/1/2024"},
    {"name": "Carmen Lim", "address": "654 Aguinaldo Blvd, Cavite", "email": "carmen.lim@email.com", "phone": "+63 921 567 8901", "points": "3,200", "pickups": 120, "status": "Active", "regDate": "8/22/2023"},
  ];

  void _showConfirmationDialog(Map<String, dynamic> resident, bool isSuspending) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
          children: [
            Text(
              isSuspending ? "Disable Resident Account?" : "Activate Resident?",
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.left, // Ensures text alignment is left
            ),
            const SizedBox(height: 16),
            Text(
              isSuspending
                  ? "Are you sure you want to disable ${resident['name']}? They will no longer be able to access the platform or request pickups."
                  : "Are you sure you want to activate ${resident['name']}? They will be able to request pickup services.",
              style: TextStyle(
                color: Colors.grey[600], 
                fontSize: 14,
                height: 1.5, // Improves readability for multi-line text
              ),
              textAlign: TextAlign.left, // Ensures text alignment is left
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel", 
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      resident['status'] = isSuspending ? "Suspended" : "Active";
                    });
                    Navigator.pop(context);
                    
                    // Show SnackBar after action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(isSuspending 
                          ? "Account for ${resident['name']} has been suspended." 
                          : "Account for ${resident['name']} has been activated."),
                        backgroundColor: isSuspending ? const Color(0xFFEF4444) : primaryGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuspending ? const Color(0xFFEF4444) : primaryGreen,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    isSuspending ? "Reject Account" : "Verify Account",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Residents", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Manage all registered residents and their accounts", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: "Search by name, email, or address...",
                        hintStyle: const TextStyle(fontSize: 14),
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => searchQuery = "");
                                })
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[200]!)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildFilterButton(),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Eco-Points', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Pickups', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Registered', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: filteredResidents.map((user) {
                    bool isSuspended = user['status'] == "Suspended";
                    return DataRow(
                      onSelectChanged: (_) => _showResidentProfile(user),
                      cells: [
                        DataCell(Text(user['name'], style: const TextStyle(fontWeight: FontWeight.w500))),
                        DataCell(Text(user['address'])),
                        DataCell(Text(user['email'])),
                        DataCell(Text(user['phone'])),
                        DataCell(Text(user['points'], style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold))),
                        DataCell(Text(user['pickups'].toString())),
                        DataCell(_buildStatusBadge(user['status'])),
                        DataCell(Text(user['regDate'])),
                        DataCell(
                          _actionButton(
                            isSuspended ? Icons.check_circle_outline : Icons.block,
                            isSuspended ? "Activate" : "Suspend",
                            isSuspended ? primaryGreen : const Color(0xFFEF4444),
                            isSuspended ? primaryGreen : const Color(0xFFEF4444),
                            () => _showConfirmationDialog(user, !isSuspended),
                            isFilled: false,
                          ),
                        ),
                      ]
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get filteredResidents {
    return residents.where((res) {
      final matchesSearch = res['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          res['email'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          res['address'].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = selectedStatus == "All Status" || res['status'] == selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _showResidentProfile(Map<String, dynamic> resident) {
    showDialog(
      context: context,
      builder: (context) => DefaultTabController(
        length: 3,
        child: Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 550,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Resident Profile",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B))),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close,
                              size: 18, color: Colors.grey)),
                    ],
                  ),
                ),
                const Divider(height: 20, thickness: 1, color: Color(0xFFF1F5F9)),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent, 
                    labelPadding: const EdgeInsets.only(right: 8),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryGreen, width: 1.5),
                    ),
                    labelColor: primaryGreen,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    tabs: [
                      _buildTabItem("Personal Info"),
                      _buildTabItem("Booking History"),
                      _buildTabItem("Eco-Points History"),
                    ],
                  ),
                ),

                Flexible(
                  child: Container(
                    height: 350,
                    padding: const EdgeInsets.all(20),
                    child: TabBarView(
                      children: [
                        _buildPersonalInfoTab(resident),
                        _buildBookingHistoryTab(),
                        _buildEcoPointsTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Tab(
        height: 20,
        child: Text(label),
      ),
    );
  }

  void _showAdjustPointsDialog(Map<String, dynamic> resident) {
    final TextEditingController pointsController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Adjust Eco-Points", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 18, color: Colors.grey), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Current Balance", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              const SizedBox(height: 4),
              Text("${resident['points']} points", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
              const SizedBox(height: 24),
              const Text("Adjustment Amount", style: TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: pointsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "e.g. 100 or -100",
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Reason", style: TextStyle(color: Color(0xFF1E293B), fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter reason for adjustment",
                  hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          int currentPoints = int.parse(resident['points'].replaceAll(',', ''));
                          int adjustment = int.tryParse(pointsController.text) ?? 0;
                          resident['points'] = NumberFormat('#,###').format(currentPoints + adjustment);
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                        _showResidentProfile(resident);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Apply Adjustment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoTab(Map<String, dynamic> res) {
    bool isSuspended = res['status'] == "Suspended";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _infoItem("Name", res['name'])),
            Expanded(child: _infoItem("Email", res['email'])),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _infoItem("Phone", res['phone'])),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Status", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  const SizedBox(height: 6),
                  _buildStatusBadge(res['status']),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _infoItem("Address", res['address']),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _infoItem("Eco-Points", res['points'], isGreen: true)),
            Expanded(child: _infoItem("Completed Pickups", res['pickups'].toString())),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _actionButton(null, "Adjust Points", Colors.white, const Color(0xFF64748B), () => _showAdjustPointsDialog(res)),
            const SizedBox(width: 12),
            _actionButton(
              isSuspended ? Icons.check_circle_outline : Icons.block,
              isSuspended ? "Activate" : "Suspend",
              isSuspended ? primaryGreen : const Color(0xFFEF4444),
              Colors.white,
              () {
                Navigator.pop(context); // Close profile
                _showConfirmationDialog(res, !isSuspended);
              },
              isFilled: true,
            ),
          ],
        )
      ],
    );
  }

  Widget _actionButton(IconData? icon, String label, Color bgColor, Color textColor, VoidCallback? onPressed, {bool isFilled = false}) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
        label: Text(label, style: const TextStyle(fontSize: 13)),
        style: OutlinedButton.styleFrom(
          backgroundColor: isFilled ? bgColor : Colors.transparent,
          foregroundColor: isFilled ? textColor : textColor,
          side: isFilled ? BorderSide.none : BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildBookingHistoryTab() {
    return Column(
      children: [
        Table(
          columnWidths: const {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(2), 2: FlexColumnWidth(2), 3: FlexColumnWidth(2)},
          children: [
            const TableRow(children: [
              Text("Booking ID", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("Date", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("Hauler", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("Status", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
              Text("Points", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
            _historyRow("BK001", "2025-01-30", "Roberto Mendoza", "completed", "+50"),
            _historyRow("BK002", "2025-01-25", "Miguel Torres", "completed", "+45"),
            _historyRow("BK003", "2025-01-20", "Carlos Villanueva", "completed", "+60"),
          ],
        ),
      ],
    );
  }

  Widget _buildEcoPointsTab() {
    return ListView(
      children: [
        _pointTile("Pickup Completion Bonus", "Jan 30, 2025", "+50", primaryGreen),
        _pointTile("Segregation Bonus", "Jan 25, 2025", "+25", primaryGreen),
        _pointTile("Redemption - Grocery Voucher", "Jan 20, 2025", "-200", Colors.red),
      ],
    );
  }

  Widget _infoItem(String label, String value, {bool isGreen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isGreen ? primaryGreen : const Color(0xFF334155)),
        ),
      ],
    );
  }

  TableRow _historyRow(String id, String date, String hauler, String status, String points) {
    return TableRow(children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(id, style: const TextStyle(fontSize: 13))),
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(date, style: const TextStyle(fontSize: 13))),
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(hauler, style: const TextStyle(fontSize: 13))),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(4)),
            child: const Text("completed", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF10B981), fontSize: 11)),
          )),
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(points, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold))),
    ]);
  }

  Widget _pointTile(String title, String date, String amount, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155))),
              Text(date, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ],
          ),
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive = status == "Active";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildFilterButton() {
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
        _buildPopupItem("Active"),
        _buildPopupItem("Suspended"),
        _buildPopupItem("Inactive"),
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
}