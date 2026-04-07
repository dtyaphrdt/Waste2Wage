import 'package:flutter/material.dart';

class HaulerModel {
  String name;
  String route;
  String phone;
  String status;
  int jobs;
  String rating;
  String transportMode; // New Column 1
  String activeLoad;    // New Column 2
  String appliedDate;
  bool isInQueue;

  HaulerModel({
    required this.name,
    required this.route,
    required this.phone,
    required this.status,
    required this.jobs,
    required this.rating,
    required this.transportMode,
    required this.activeLoad,
    this.appliedDate = "",
    this.isInQueue = false,
  });
}

class AdminHaulers extends StatefulWidget {
  final String searchQuery;
  const AdminHaulers({super.key, this.searchQuery = ""});

  @override
  State<AdminHaulers> createState() => _AdminHaulersState();
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  const _TabButton({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        border: Border.all(color: isActive ? const Color(0xFF27AE60) : Colors.transparent),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isActive ? const Color(0xFF27AE60) : Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }
}

class _AdminHaulersState extends State<AdminHaulers> {
  final Color primaryGreen = const Color(0xFF27AE60);
  final Color pendingOrange = const Color(0xFFF39C12);
  final Color borderColor = const Color(0xFFE5E7EB);
  final Color bgLightOrange = const Color(0xFFFFF9F2);
  final Color rejectRed = const Color(0xFFEF4444);
  final Color lightGreenBg = const Color(0xFFE8F5E9);
  final Color bgLight = const Color(0xFFF9FAFB); 

  String searchQuery = "";
  String statusFilter = "All Status";
  
  late List<HaulerModel> haulers;

  @override
  void initState() {
    super.initState();
    haulers = [
      HaulerModel(name: "Roberto Mendoza", route: "Makati - BGC", phone: "+63 922 111 2222", status: "Verified", jobs: 234, rating: "4.8", transportMode: "Bicycle", activeLoad: "3/5"),
      HaulerModel(name: "Juan Ramos", route: "Quezon City North", phone: "+63 923 222 3333", status: "Pending", jobs: 0, rating: "-", transportMode: "Pushcart", activeLoad: "0/3", appliedDate: "1/28/2025", isInQueue: true),
      HaulerModel(name: "Miguel Torres", route: "Manila Central", phone: "+63 924 333 4444", status: "Verified", jobs: 189, rating: "4.5", transportMode: "Walking", activeLoad: "1/2"),
      HaulerModel(name: "Dominador Cruz", route: "Pasig - Mandaluyong", phone: "+63 925 444 5555", status: "Pending", jobs: 0, rating: "-", transportMode: "Bicycle", activeLoad: "0/5", appliedDate: "1/30/2025", isInQueue: true),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final queueItems = haulers.where((h) => h.isInQueue).toList();
    
    final filteredTableItems = haulers.where((h) {
      final matchesSearch = h.name.toLowerCase().contains(searchQuery.toLowerCase()) || 
                            h.route.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = statusFilter == "All Status" || h.status == statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Haulers", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Manage hauler accounts and verification queue", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 24),

            if (queueItems.isNotEmpty) ...[
              _buildVerificationQueue(queueItems),
              const SizedBox(height: 24),
            ],

            _buildTableToolbar(),
            _buildHaulersTable(filteredTableItems),
          ],
        ),
      ),
    );
  }

  void _approveHauler(HaulerModel hauler) {
    setState(() {
      hauler.status = "Verified";
      hauler.isInQueue = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("${hauler.name} has been verified and added to the list."),
        backgroundColor: primaryGreen,
      ),
    );
  }

  void _rejectHauler(HaulerModel hauler) {
    setState(() {
      hauler.status = "Rejected";
      hauler.isInQueue = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("${hauler.name}'s verification was rejected."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _disableHauler(HaulerModel hauler) {
    setState(() {
      hauler.status = "Rejected"; 
      hauler.isInQueue = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("${hauler.name} has been rejected."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showViewIDDialog(HaulerModel hauler) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ID Verification Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(hauler.name, style: TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 20)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.image_outlined, size: 64, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: primaryGreen), foregroundColor: Colors.black87),
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () { Navigator.pop(context); _showConfirmDialog(hauler, true); },
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text("Approve"),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () { Navigator.pop(context); _showConfirmDialog(hauler, false); },
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text("Reject"),
                    style: ElevatedButton.styleFrom(backgroundColor: rejectRed, foregroundColor: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(HaulerModel hauler, bool isApprove) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        title: Text(isApprove ? "Approve Hauler?" : "Reject Hauler?", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(isApprove 
          ? "Are you sure you want to verify ${hauler.name}? They will be able to accept pickup requests." 
          : "Are you sure you want to reject ${hauler.name}'s verification? They will need to resubmit their documents."),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(side: BorderSide(color: primaryGreen)),
            child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              isApprove ? _approveHauler(hauler) : _rejectHauler(hauler);
            },
            style: ElevatedButton.styleFrom(backgroundColor: isApprove ? primaryGreen : rejectRed),
            child: Text(isApprove ? "Verify Account" : "Reject", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationQueue(List<HaulerModel> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bgLightOrange, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFFE5CC))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.circle, size: 8, color: pendingOrange),
            const SizedBox(width: 8),
            Text("ID Verification Queue (${items.length})", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ]),
          const SizedBox(height: 16),
          Row(children: items.map((h) => _verificationCard(h)).toList()),
        ],
      ),
    );
  }

  Widget _verificationCard(HaulerModel hauler) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
        child: Row(
          children: [
            Container(height: 48, width: 48, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.image_outlined, color: Colors.grey)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(hauler.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(hauler.route, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text("Applied: ${hauler.appliedDate}", style: TextStyle(color: Colors.grey[400], fontSize: 11)),
            ])),
            _btn("View ID", Icons.visibility_outlined, Colors.white, Colors.black87, border: true, onTap: () => _showViewIDDialog(hauler)),
            const SizedBox(width: 8),
            _btn("Approve", Icons.check_circle_outline, primaryGreen, Colors.white, onTap: () => _showConfirmDialog(hauler, true)),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _showConfirmDialog(hauler, false),
              child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: rejectRed, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.cancel_outlined, color: Colors.white, size: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, IconData icon, Color bg, Color text, {bool border = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6), border: border ? Border.all(color: borderColor) : null),
        child: Row(children: [Icon(icon, size: 16, color: text), const SizedBox(width: 6), Text(label, style: TextStyle(color: text, fontSize: 13, fontWeight: FontWeight.w500))]),
      ),
    );
  }

  Widget _buildTableToolbar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Search by Name, Route...",
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
          const SizedBox(width: 12),
          _filterDropdown(context, "All Status", ["All Status", "Verified", "Pending", "Rejected"]),
        ],
      ),
    );
  }

  Widget _buildHaulersTable(List<HaulerModel> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
          ),
        child: Column(
        children: [
          _tableHeader(),
          ...items.asMap().entries.map((entry) => _haulerRow(entry.value, isLast: entry.key == items.length - 1)),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), border: Border(bottom: BorderSide(color: borderColor))),
      child: const Row(children: [
        Expanded(flex: 2, child: Text("Name", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(flex: 2, child: Text("Route", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(flex: 2, child: Text("Transport Mode", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))), // New Col 1
        Expanded(flex: 2, child: Text("Active Load", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),   // New Col 2
        Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(flex: 1, child: Text("Jobs", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        Expanded(flex: 1, child: Text("Rating", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        SizedBox(width: 110, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
      ]),
    );
  }

  Widget _haulerRow(HaulerModel h, {bool isLast = false}) {
    Color bgColor;
    Color textColor;
    Color borderColorStatus;

    if (h.status == "Verified") {
      bgColor = const Color(0xFFECFDF5);
      textColor = const Color(0xFF059669);
      borderColorStatus = const Color(0xFFA7F3D0);
    } else if (h.status == "Pending") {
      bgColor = const Color(0xFFFFF7ED);
      textColor = const Color(0xFFD97706);
      borderColorStatus = const Color(0xFFFFEDD5);
    } else { // Rejected
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFEF4444);
      borderColorStatus = const Color(0xFFFECACA);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showHaulerProfile(h),
        hoverColor: Colors.grey[200],
        mouseCursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            border: isLast ? null : Border(bottom: BorderSide(color: borderColor)),
          ),
          child: Row(
            children: [
            Expanded(flex: 2, child: Text(h.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
            Expanded(flex: 2, child: Text(h.route, style: const TextStyle(fontSize: 14))),
            Expanded(flex: 2, child: Text(h.transportMode, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))), // New Col 1
            Expanded(flex: 2, child: Text(h.activeLoad, style: TextStyle(fontSize: 14, color: primaryGreen, fontWeight: FontWeight.bold))), // New Col 2
            Expanded(flex: 2, child: Row(children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColorStatus),
                  ),
                  child: Text(h.status, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ])),
              Expanded(flex: 1, child: Text("${h.jobs}")),
              Expanded(flex: 1, child: Row(children: [if (h.rating != "-") const Icon(Icons.star, color: Colors.orange, size: 14), const SizedBox(width: 4), Text(h.rating)])),
              SizedBox(
                width: 110, 
                child: _buildActionsMenu(h),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterDropdown(BuildContext context, String currentLabel, List<String> options) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() => statusFilter = value);
      },
      offset: const Offset(0, 10),
      position: PopupMenuPosition.under,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (BuildContext context) => options.map((opt) => _buildStatusItem(opt)).toList(),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Text(statusFilter, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildStatusItem(String value) {
    bool isSelected = statusFilter == value;
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

  Widget _buildActionsMenu(HaulerModel h) {
    bool isVerified = h.status == "Verified";
    bool isRejected = h.status == "Rejected";

    if (!isVerified && !isRejected) return const SizedBox.shrink();

    // Professional semantic colors for text and hover background
    final Color actionColor = isVerified ? const Color(0xFFDC2626) : const Color(0xFF059669); 
    final Color hoverBgColor = isVerified ? const Color.fromARGB(255, 254, 236, 236) : const Color.fromARGB(255, 235, 255, 241);
    
    final String label = isVerified ? "Reject" : "Verify";
    final IconData icon = isVerified ? Icons.block_outlined : Icons.verified_user_outlined;
    
    final VoidCallback action = isVerified 
        ? () => _showDisableConfirmDialog(h) 
        : () => _showConfirmDialog(h, true);

    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setInternalState) {
        return MouseRegion(
          onEnter: (_) => setInternalState(() => isHovered = true),
          onExit: (_) => setInternalState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: action,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                // Background turns to light shade on hover, otherwise white
                color: isHovered ? hoverBgColor : Colors.white,
                borderRadius: BorderRadius.circular(8),
                // Fixed border color as requested
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 14, color: actionColor),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: actionColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showHaulerProfile(HaulerModel hauler) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: 550, // Slightly wider to accommodate document side-by-side if needed
            padding: const EdgeInsets.all(24),
            child: DefaultTabController(
              length: 4, // Updated length from 3 to 4
              child: Builder(builder: (context) {
                final TabController tabController = DefaultTabController.of(context);
                return AnimatedBuilder(
                  animation: tabController,
                  builder: (context, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Hauler Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 20)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          indicatorColor: Colors.transparent,
                          dividerColor: Colors.transparent,
                          labelPadding: const EdgeInsets.only(right: 8),
                          tabs: [
                            Tab(child: _TabButton(label: "Information", isActive: tabController.index == 0)),
                            Tab(child: _TabButton(label: "Documents", isActive: tabController.index == 1)), // New Documents Tab
                            Tab(child: _TabButton(label: "Performance", isActive: tabController.index == 2)),
                            Tab(child: _TabButton(label: "Ratings", isActive: tabController.index == 3)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 320, // Increased height for document previews
                          child: TabBarView(
                            children: [
                              _buildInformationTab(hauler),
                              _buildDocumentsTab(hauler), // New Documents View
                              _buildPerformanceTab(),
                              _buildRatingsTab(),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentsTab(HaulerModel h) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verification Documents - ${h.transportMode}", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _documentPreview("Government Issued ID", Icons.badge_outlined)),
              const SizedBox(width: 16),
              Expanded(child: _documentPreview("Vehicle/Equipment Photo", Icons.pedal_bike_outlined)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightGreenBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: primaryGreen),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Verify these documents match the Transport Mode before assigning a Plate Number.",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentPreview(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.grey),
              const SizedBox(height: 8),
              Text("Click to expand", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInformationTab(HaulerModel h) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              _infoItem("Name", h.name),
              _infoItem("Phone", h.phone),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoItem("Transport Mode", h.transportMode), // Added to Pop-up
              _infoItem("Active Load", h.activeLoad, color: primaryGreen), // Added to Pop-up
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoItem("Route", h.route),
              _statusInfoItem("Account Status", h.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _infoItem("Total Jobs", "${h.jobs}"),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Rating", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.star, color: Colors.orange, size: 16), Text(" ${h.rating}", style: const TextStyle(fontWeight: FontWeight.bold))]),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return Column(
      children: [
        const Row(children: [
          Expanded(child: Text("Date", style: TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text("Pickups", style: TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text("Rating", style: TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text("Earnings", style: TextStyle(color: Colors.grey, fontSize: 13))),
        ]),
        const Divider(height: 24),
        _performanceRow("2025-01-30", "8", "4.9", "₱1,200"),
        _performanceRow("2025-01-29", "6", "4.7", "₱900"),
        _performanceRow("2025-01-28", "10", "5", "₱1,500"),
      ],
    );
  }

  Widget _buildRatingsTab() {
    return ListView(
      children: [
        _ratingCard("Very professional and on time!", "Maria Santos - Jan 30, 2025", 5),
        const SizedBox(height: 12),
        _ratingCard("Good service, arrived a bit late.", "Juan Dela Cruz - Jan 28, 2025", 4),
      ],
    );
  }

  Widget _infoItem(String label, String value, {Color? color}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _statusInfoItem(String label, String status) {
    Color bgColor;
    Color textColor;
    Color borderColorStatus;

    if (status == "Verified") {
      bgColor = const Color(0xFFECFDF5);
      textColor = const Color(0xFF059669);
      borderColorStatus = const Color(0xFFA7F3D0);
    } else if (status == "Pending") {
      bgColor = const Color(0xFFFFF7ED);
      textColor = const Color(0xFFD97706);
      borderColorStatus = const Color(0xFFFFEDD5);
    } else { // Rejected
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFEF4444);
      borderColorStatus = const Color(0xFFFECACA);
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColorStatus),
                ),
                child: Text(status, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _performanceRow(String date, String pickups, String rating, String earnings) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(children: [
        Expanded(child: Text(date, style: const TextStyle(fontSize: 13))),
        Expanded(child: Text(pickups, style: const TextStyle(fontSize: 13))),
        Expanded(child: Row(children: [const Icon(Icons.star, color: Colors.orange, size: 14), Text(" $rating", style: const TextStyle(fontSize: 13))])),
        Expanded(child: Text(earnings, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
      ]),
    );
  }

  Widget _ratingCard(String comment, String user, int stars) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: borderColor), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < stars ? Colors.orange : Colors.grey[300]))),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(height: 4),
          Text(user, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        ],
      ),
    );
  }
  
  void _showDisableConfirmDialog(HaulerModel hauler) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        title: const Text("Disable Hauler Account?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to disable ${hauler.name}? They will no longer be able to access the platform or accept jobs."),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(side: BorderSide(color: borderColor)),
            child: const Text("Cancel", style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _disableHauler(hauler);
            },
            style: ElevatedButton.styleFrom(backgroundColor: rejectRed),
            child: const Text("Reject Account", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}