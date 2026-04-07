import 'package:flutter/material.dart';
import 'resident_home.dart'; // [FIXED] Import Home Screen

class ResidentBookingsScreen extends StatefulWidget {
  const ResidentBookingsScreen({super.key});

  @override
  State<ResidentBookingsScreen> createState() => _ResidentBookingsScreenState();
}

class _ResidentBookingsScreenState extends State<ResidentBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- COLORS ---
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      
      // 1. COMPACT GREEN HEADER
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
            color: headerGreen,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                   // [FIXED] Now goes back to ResidentHomeScreen
                   Navigator.pushReplacement(
                     context, 
                     MaterialPageRoute(builder: (context) => const ResidentHomeScreen())
                   );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.green, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 15),
              const Text(
                "My Bookings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),

      // 2. BODY
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          // GREY TRACK TAB BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 55,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[300], 
                borderRadius: BorderRadius.circular(15), 
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.black, 
                unselectedLabelColor: Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Past"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          // TAB CONTENT
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // --- UPCOMING TAB ---
                ListView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    BookingCard(
                      status: "Scheduled",
                      id: "TXN-004",
                      wasteType: "Organic",
                      isSegregated: true,
                      bags: 3,
                      date: "Tue, Feb 11",
                      time: "09:00 AM",
                      address: "123 Green Street",
                      haulerName: "Juan Santos",
                      haulerRating: "4.8",
                      haulerVehicle: "HAU-001",
                    ),
                    SizedBox(height: 15),
                    BookingCard(
                      status: "Scheduled",
                      id: "TXN-005",
                      wasteType: "Recyclable",
                      isSegregated: true,
                      bags: 2,
                      date: "Thu, Feb 13",
                      time: "02:00 PM",
                      address: "123 Green Street",
                      haulerName: "Pedro Penduko",
                      haulerRating: "4.9",
                      haulerVehicle: "HAU-005",
                    ),
                  ],
                ),

                // --- PAST TAB ---
                ListView(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    BookingCard(
                      status: "Completed",
                      id: "TXN-003",
                      wasteType: "Organic",
                      isSegregated: true,
                      bags: 3,
                      date: "Tue, Feb 04",
                      time: "09:00 AM",
                      address: "123 Green Street",
                      haulerName: "Juan Santos",
                      haulerRating: "4.8",
                      haulerVehicle: "HAU-001",
                      ecoPoints: 15,
                    ),
                    SizedBox(height: 15),
                    BookingCard(
                      status: "Completed",
                      id: "TXN-002",
                      wasteType: "Mixed Waste",
                      isSegregated: false,
                      bags: 3,
                      date: "Mon, Jan 28",
                      time: "09:00 AM",
                      address: "123 Green Street",
                      haulerName: "Juan Santos",
                      haulerRating: "4.8",
                      haulerVehicle: "HAU-001",
                      ecoPoints: 10,
                    ),
                    SizedBox(height: 15),
                    BookingCard(
                      status: "Cancelled",
                      id: "TXN-001",
                      wasteType: "Mixed Waste",
                      isSegregated: false,
                      bags: 1,
                      date: "Fri, Jan 20",
                      time: "09:00 AM",
                      address: "123 Green Street",
                      haulerName: "N/A",
                      haulerRating: "",
                      haulerVehicle: "",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE BOOKING CARD WIDGET ---
class BookingCard extends StatelessWidget {
  final String status;
  final String id;
  final String wasteType;
  final bool isSegregated;
  final int bags;
  final String date;
  final String time;
  final String address;
  final String haulerName;
  final String haulerRating;
  final String haulerVehicle;
  final int? ecoPoints;

  const BookingCard({
    super.key,
    required this.status,
    required this.id,
    required this.wasteType,
    required this.isSegregated,
    required this.bags,
    required this.date,
    required this.time,
    required this.address,
    required this.haulerName,
    required this.haulerRating,
    required this.haulerVehicle,
    this.ecoPoints,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBg;
    Color statusText;
    IconData statusIcon;

    if (status == "Scheduled") {
      statusBg = const Color(0xFFE0E7FF);
      statusText = const Color(0xFF4F46E5);
      statusIcon = Icons.access_time_filled;
    } else if (status == "Completed") {
      statusBg = const Color(0xFFDCF8C6);
      statusText = const Color(0xFF388E3C);
      statusIcon = Icons.check_circle;
    } else { 
      statusBg = const Color(0xFFFFE0E0);
      statusText = const Color(0xFFD32F2F);
      statusIcon = Icons.cancel;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: statusBg.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(statusIcon, color: statusText, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusText,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  id,
                  style: TextStyle(
                    color: statusText,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wasteType,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        if (isSegregated)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Text("Segregated", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                SizedBox(width: 2),
                                Icon(Icons.check, color: Colors.white, size: 10)
                              ],
                            ),
                          ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "$bags bags",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildInfoRow(Icons.calendar_today, date),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, time),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on_outlined, address),
                const SizedBox(height: 20),
                const Divider(thickness: 1, height: 1),
                const SizedBox(height: 15),
                if (status != "Cancelled") ...[
                  const Text("Hauler Details", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              haulerName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  haulerRating,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "•  $haulerVehicle",
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (status == "Scheduled")
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.phone, size: 20, color: Colors.black54),
                        ),
                    ],
                  ),
                ],
                if (status == "Completed" && ecoPoints != null) ...[
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Eco-Points Earned", style: TextStyle(color: Colors.black54, fontSize: 12)),
                        Text("+$ecoPoints EP", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
                if (status == "Cancelled")
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "This request was cancelled by the user.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}