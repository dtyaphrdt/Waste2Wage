import 'package:flutter/material.dart';

class AdminAuditLog extends StatefulWidget {
  const AdminAuditLog({super.key});

  @override
  State<AdminAuditLog> createState() => _AdminAuditLogState();
}

class _AdminAuditLogState extends State<AdminAuditLog> {
  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color textDark = const Color(0xFF2C3E50);

  // Search Controller
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Data structures
  final List<Map<String, String>> _pendingDisputes = [
    {
      "serviceId": "SVC-2025-0145",
      "reason": "Hauler claims waste was not segregated, resident disagrees.",
      "timestamp": "2025-01-30 14:32:00",
      "residentName": "Maria Santos",
      "haulerName": "Miguel Torres",
    },
    {
      "serviceId": "SVC-2025-0142",
      "reason": "Pickup location mismatch.",
      "timestamp": "2025-01-29 09:15:00",
      "residentName": "Juan Dela Cruz",
      "haulerName": "Roberto Mendoza",
    },
  ];

  final List<Map<String, String>> _resolvedDisputes = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resolveDispute(String serviceId, String status) {
    setState(() {
      final index = _pendingDisputes.indexWhere((d) => d['serviceId'] == serviceId);
      if (index != -1) {
        final dispute = _pendingDisputes.removeAt(index);
        dispute['status'] = status;
        _resolvedDisputes.add(dispute);
      }
    });
    Navigator.pop(context);
  }

  // Filter Helper Logic
  List<Map<String, String>> _getFilteredList(List<Map<String, String>> list) {
    if (_searchQuery.isEmpty) return list;
    return list.where((item) {
      final query = _searchQuery.toLowerCase();
      return item['serviceId']!.toLowerCase().contains(query) ||
          item['residentName']!.toLowerCase().contains(query) ||
          item['haulerName']!.toLowerCase().contains(query);
    }).toList();
  }

  void _showRefundDialog(String residentName, String serviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text("Refund Resident?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(
          "This will refund the resident ($residentName) for this service and record the dispute as resolved in their favor.",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2ECC71)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF2ECC71))),
          ),
          ElevatedButton(
            onPressed: () => _resolveDispute(serviceId, "Refunded"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2ECC71),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: const Text("Confirm Refund", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUpholdDialog(String residentName, String haulerName, String serviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text("Uphold Penalty?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(
          "This will uphold the penalty against the resident ($residentName) and close the dispute in favor of the hauler ($haulerName).",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2ECC71)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF2ECC71))),
          ),
          ElevatedButton(
            onPressed: () => _resolveDispute(serviceId, "Upheld"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              elevation: 0,
            ),
            child: const Text("Uphold Penalty", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPending = _getFilteredList(_pendingDisputes);
    final filteredResolved = _getFilteredList(_resolvedDisputes);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Audit Log / Dispute Resolution",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Review and resolve disputes between residents and haulers",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Search Bar with Functionality
            SizedBox(
              width: 1025,
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by Service ID, resident, or hauler...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 18),
                  suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = "");
                        },
                      ) 
                    : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pending Disputes Section
            if (filteredPending.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.gavel_rounded, color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Pending Disputes (${filteredPending.length})",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    ...filteredPending.map((d) => Column(
                      children: [
                        _buildDisputeCard(
                          serviceId: d['serviceId']!,
                          reason: d['reason']!,
                          timestamp: d['timestamp']!,
                          residentName: d['residentName']!,
                          haulerName: d['haulerName']!,
                        ),
                        if (filteredPending.last != d) const Divider(height: 1),
                      ],
                    )),
                  ],
                ),
              ),

            if (filteredPending.isEmpty && _searchQuery.isNotEmpty && filteredResolved.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No results found."),
              )),

            const SizedBox(height: 24),

            // Resolved Disputes Section
            if (filteredResolved.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Resolved Disputes",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    ...filteredResolved.map((d) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade100)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(d['serviceId']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Text("${d['residentName']} vs ${d['haulerName']}", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(d['timestamp']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: d['status'] == "Refunded" ? Colors.blue.shade50 : const Color.fromARGB(255, 245, 232, 232),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: d['status'] == "Refunded" ? Colors.blue.shade100 : const Color.fromARGB(255, 230, 200, 200)),
                            ),
                            child: Text(
                              d['status']!,
                              style: TextStyle(
                                color: d['status'] == "Refunded" ? Colors.blue : const Color.fromARGB(255, 175, 76, 76),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ... (Other methods: _buildDisputeCard, _buildPhotoBox, _infoLabel remain the same)
  Widget _buildDisputeCard({
    required String serviceId,
    required String reason,
    required String timestamp,
    required String residentName,
    required String haulerName,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildPhotoBox("Before Collection Photo", residentName),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildPhotoBox("After Disposal Photo", haulerName),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoLabel("Service ID"),
                  Text(serviceId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 12),
                  _infoLabel("Reason"),
                  Text(reason, style: const TextStyle(fontSize: 12, height: 1.4)),
                  const SizedBox(height: 12),
                  _infoLabel("Timestamp"),
                  Text(timestamp, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showRefundDialog(residentName, serviceId),
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text("Refund"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: textDark,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showUpholdDialog(residentName, haulerName, serviceId),
                          icon: const Icon(Icons.block, size: 16),
                          label: const Text("Uphold"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoBox(String label, String userName) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
        const SizedBox(height: 8),
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(userName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  Widget _infoLabel(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.w500),
    );
  }
}