import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; 
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'resident_home.dart';
import 'resident_schedule_pickup.dart';
import 'resident_chatscreen.dart';
import 'resident_feedback.dart';

class ResidentTrackHaulerScreen extends StatefulWidget {
  const ResidentTrackHaulerScreen({super.key});

  @override
  State<ResidentTrackHaulerScreen> createState() => _ResidentTrackHaulerScreenState();
}

class _ResidentTrackHaulerScreenState extends State<ResidentTrackHaulerScreen> {
  int _currentStep = 0;
  bool _isCancelled = false;
  
  final List<LatLng> _routePoints = [
    const LatLng(14.5995, 120.9842), 
    const LatLng(14.6010, 120.9850), 
    const LatLng(14.6025, 120.9865), 
    const LatLng(14.6040, 120.9875), 
  ];

  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _simulateTracking();
  }

  void _simulateTracking() async {
    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && !_isCancelled) {
        setState(() {
          _currentStep = i;
        });
        _mapController.move(_routePoints[i], 15.0);
        if (_currentStep == 3) {
          _navigateToFeedback();
        }
      }
    }
  }

  void _navigateToFeedback() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && !_isCancelled) {
        // Show the snackbar as per your original code
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hauler Arrived! Navigating to Feedback..."))
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResidentFeedbackScreen(), // Ensure this class name matches your file
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color bgCream = Color(0xFFFFF8F3);
    const Color headerGreen = Color(0xFFDCF8C6);
    const Color brandTeal = Color(0xFF1EBE71);
    
    return Scaffold(
      backgroundColor: bgCream,
      appBar: _buildAppBar(headerGreen),
      body: Column(
        children: [
          _buildOSMMap(brandTeal), 
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0, -30, 0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StatusStepper(currentStep: _currentStep),
                      const SizedBox(height: 20),
                      _buildHaulerCard(brandTeal, const Color(0xFF388E3C)),
                      const SizedBox(height: 25),
                      const Text("Pickup Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildDetailsGrid(),
                      const Divider(height: 40),
                      _buildTotalAmount(brandTeal),
                      const SizedBox(height: 30),
                      _buildCancelButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleCancellation() {
    setState(() {
      _isCancelled = true;
    });
  }

  Widget _buildOSMMap(Color brandTeal) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _routePoints[0],
              initialZoom: 15.0,
            ),
            children: [
              // OPEN STREET MAP LAYER
              TileLayer(
              urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.waste2wage.app',
              tileProvider: CancellableNetworkTileProvider(),
            ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _routePoints[_currentStep],
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Icon(Icons.directions_walk, color: brandTeal, size: 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 20, left: 20, right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBadge(Icons.access_time, "ETA", _currentStep == 3 ? "Arrived" : "${8 - (_currentStep * 2)} mins"),
                _buildInfoBadge(Icons.near_me_outlined, "Distance", _currentStep == 3 ? "0 km" : "${(1.3 - (_currentStep * 0.4)).toStringAsFixed(1)} km"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color headerGreen) {
    return PreferredSize(
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
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
              ),
              icon: const Icon(Icons.arrow_back, color: Colors.green, size: 28),
            ),
            const SizedBox(width: 15),
            const Text("Track Hauler", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildHaulerCard(Color brandTeal, Color textGreen) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: brandTeal, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Colors.white, child: Text("JS", style: TextStyle(color: Color(0xFF388E3C)))),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Juan Santos", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                Text("⭐ 4.8 • HAU-001", style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResidentChatscreen())),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () => _makePhoneCall('09123456789'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Column(
      children: [
        Row(children: [
          _detailItem(Icons.delete_outline, "Waste Type", "Mixed Waste"),
          const SizedBox(width: 10),
          _detailItem(Icons.inventory_2_outlined, "Bags", "3 bags"),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _detailItem(Icons.calendar_today_outlined, "Scheduled", "Mon, Feb 10\n9:00 AM"),
          const SizedBox(width: 10),
          _detailItem(Icons.tag, "Tracking Number", "HAU-7829"),
        ]),
      ],
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1FBEB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount(Color brandTeal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Total Amount", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("₱60.00", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: brandTeal)),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => showCancelPickupDialog(context, onCancelConfirmed: handleCancellation),
        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
        child: const Text("Cancel Pickup", style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.green),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}

class _StatusStepper extends StatelessWidget {
  final int currentStep;
  const _StatusStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _stepIcon(Icons.check_circle, "Confirmed", currentStep >= 0),
            _stepIcon(Icons.directions_walk, "En Route", currentStep >= 1),
            _stepIcon(Icons.near_me, "Nearby", currentStep >= 2),
            _stepIcon(Icons.location_on, "Arrived", currentStep >= 3),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(height: 6, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3))),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 6,
              width: MediaQuery.of(context).size.width * (0.2 + (currentStep * 0.2)),
              decoration: BoxDecoration(color: const Color(0xFF1EBE71), borderRadius: BorderRadius.circular(3)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepIcon(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? const Color(0xFF1EBE71) : Colors.grey[300],
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }
}


void showCancelPickupDialog(BuildContext context, {required VoidCallback onCancelConfirmed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 15),
              const Text("Cancel Pickup?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text("Please review the cancellation policy", style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
              _policyCard(
                color: const Color(0xFFE8F5E9),
                icon: Icons.access_time,
                iconColor: Colors.green,
                title: "Cancel within 5 minutes",
                subtitle: "Completely FREE - no penalty",
                titleColor: Colors.green,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Keep Tracking"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onCancelConfirmed(); // Stop the simulation
                        Navigator.pop(context); // Close dialog
                        Navigator.pushReplacement( // Direct to Cancelled Screen
                          context,
                          MaterialPageRoute(builder: (context) => const PickupCancelledScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _policyCard({
  required Color color,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required Color titleColor,
}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: titleColor.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.5), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: titleColor.withValues(alpha: 0.8))),
          ],
        )
      ],
    ),
  );
}

class PickupCancelledScreen extends StatelessWidget {
  const PickupCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF1EBE71);
    const Color bgCream = Color(0xFFFFF8F3);

    return Scaffold(
      backgroundColor: bgCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Success Icon
              const Icon(
                Icons.check_circle,
                color: brandGreen,
                size: 120,
              ),
              const SizedBox(height: 20),

              // 2. Title and Order ID
              const Text(
                "Pickup Cancelled",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Order #TXN-004 has been successfully cancelled",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // 3. Refund Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      "Refund Amount",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "₱60.00",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: brandGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Will be credited to your account within 2-3 business days",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // 4. Action Buttons
              _buildButton(
                label: "Schedule New Pickup",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ResidentSchedulePickupScreen()),
                  );
                },
                isPrimary: true,
              ),
              const SizedBox(height: 15),
              _buildButton(
                label: "Back to Home",
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
                  );
                },
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed, required bool isPrimary}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF1EBE71) : Colors.grey[300],
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF388E3C),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}