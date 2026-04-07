import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'resident_home.dart';

class ResidentSchedulePickupScreen extends StatefulWidget {
  const ResidentSchedulePickupScreen({super.key});

  @override
  State<ResidentSchedulePickupScreen> createState() => _ResidentSchedulePickupScreenState();
}

class _ResidentSchedulePickupScreenState extends State<ResidentSchedulePickupScreen> {
  // --- STATE VARIABLES ---
  int _currentStep = 0;

  // Data Vars
  String _selectedWasteType = "Recyclable";
  int _bagCount = 1;
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = "08:00 AM";

  // Location Data
  LatLng _sauyoLocation = const LatLng(14.6855, 121.0450); 
  String _currentAddress = "123 West St, Brgy Sauyo, QC";

  // [GEOFENCING] Defined Bounds of Barangay Sauyo
  final LatLngBounds _sauyoBounds = LatLngBounds(
    const LatLng(14.6800, 121.0300), 
    const LatLng(14.7100, 121.0600), 
  );

  // Demo Addresses
  final List<String> _demoAddresses = [
    "45 Old Sauyo Road, Brgy Sauyo, QC",
    "88 Sampaguita St, Green Fields, QC",
    "Block 5 Lot 2, Kawayan Street, QC",
    "101 Marian Subdivision, Sauyo, QC",
    "Near Sauyo Elementary School, QC",
    "Corner Richland V, Brgy Sauyo, QC"
  ];

  // Payment Vars
  String _selectedPayment = "Cash on Pickup";
  final double _simulatedGcashBalance = 500.00; 
  final double _simulatedEcoPoints = 50.00;     

  bool _isSegregated = false;
  bool _agreedToTerms = false;

  // Pricing
  static const double _perBagFee = 20.00;
  static const double _pesoPerEcoPoint = 0.20;

  double get _totalFee => _bagCount * _perBagFee;
  int get _requiredEcoPoints => (_totalFee / _pesoPerEcoPoint).ceil();
  int get _pointsToEarn => _isSegregated ? 15 : 7;

  // Lists
  final List<Map<String, dynamic>> _wasteTypes = const [
    {"name": "Recyclable", "desc": "Plastic, paper, metal, glass", "icon": Icons.recycling},
    {"name": "Organic", "desc": "Food waste, garden waste", "icon": Icons.eco},
    {"name": "Mixed Waste", "desc": "General household waste", "icon": Icons.delete_outline},
  ];

  final List<String> _times = const [
    "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM",
    "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM"
  ];

  // Colors
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);
  final Color primaryGreen = const Color(0xFF2ECC71);

  @override
  Widget build(BuildContext context) {
    bool isLastStep = _currentStep == 2;

    return Scaffold(
      backgroundColor: bgCream,
      body: Column(
        children: [
          // 1. HEADER (Title Only)
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: headerGreen,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                IconButton(
                onPressed: ()  {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
                  );          
                },
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                ),
                const SizedBox(width: 10),
                Text(
                  "Schedule Pickup",
                  style: TextStyle(color: textGreen, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 2. SCROLLABLE CONTENT
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              physics: const BouncingScrollPhysics(),
              children: [
                // STEPPER CARD (The "Second Pic" Style)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: _buildCustomStepper(),
                ),

                const SizedBox(height: 25),

                // DYNAMIC CONTENT
                _buildCurrentStepContent(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 3. BOTTOM BUTTON
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleNextButton,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                child: Text(
                  isLastStep ? "Confirm Pickup" : "Next",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // --- NEW STEPPER WIDGET ---
  Widget _buildCustomStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStepItem(0, "Waste Type"),
        _buildStepLine(0),
        _buildStepItem(1, "Schedule"),
        _buildStepLine(1),
        _buildStepItem(2, "Confirm"),
      ],
    );
  }

  Widget _buildStepItem(int index, String label) {
    // If we are ON this step, or PAST this step, highlight it
    bool isActiveOrCompleted = _currentStep >= index;
    
    // Specifically active (current step)
    bool isActive = _currentStep == index;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActiveOrCompleted ? primaryGreen : const Color(0xFFFFF1EB), // Green if active/done, Cream if not
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "${index + 1}",
              style: TextStyle(
                color: isActiveOrCompleted ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int index) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.only(bottom: 20), // Align with circles
        // Line is green if we have passed this step (moved to next)
        color: _currentStep > index ? primaryGreen : Colors.grey[200],
      ),
    );
  }

  // --- LOGIC & CONTENT ---
  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0: return _buildStep1Waste();
      case 1: return _buildStep2ScheduleAndLocation();
      case 2: return _buildStep3PaymentAndConfirm();
      default: return Container();
    }
  }

  void _handleNextButton() {
    if (_currentStep < 2) {
      // Step 1 Validation
      if (_currentStep == 0 && _bagCount == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please add at least 1 bag.")));
        return;
      }
      
      // Step 2 Validation: GEOFENCING
      if (_currentStep == 1) {
        if (!_sauyoBounds.contains(_sauyoLocation)) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Out of Service Area", style: TextStyle(color: Colors.red)),
              content: const Text("Sorry, Waste2Wage currently only operates within Barangay Sauyo. Please select a location inside the highlighted area."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Okay"),
                )
              ],
            ),
          );
          return;
        }
      }

      setState(() => _currentStep++);
    } else {
      // Final Step Validation
      if (_selectedPayment == "GCash") {
        if (_simulatedGcashBalance < _totalFee) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient GCash Balance.")));
          return;
        }
      }
      if (_selectedPayment == "Use Eco-Points") {
        if (_simulatedEcoPoints < _requiredEcoPoints) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient Eco-Points.")));
           return;
        }
      }

      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please agree to the terms.")));
        return;
      }

      _showConfirmationDialog();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: primaryGreen, onPrimary: Colors.white, onSurface: textGreen),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // --- STEP 1 ---
  Widget _buildStep1Waste() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Select Waste Type"),
        ..._wasteTypes.map((type) => _buildWasteTypeCard(type["name"], type["desc"], type["icon"])),
        const SizedBox(height: 20),
        _buildSectionTitle("Estimated Quantity"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, color: Colors.lightGreen, size: 30),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$_bagCount Bag${_bagCount > 1 ? 's' : ''}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis),
                          const Text("Standard garbage bags",
                              style: TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildQuantityButton(Icons.remove, () {
                    if (_bagCount > 0) {
                      setState(() => _bagCount--);
                    }
                  }),
                  const SizedBox(width: 10),
                  _buildQuantityButton(Icons.add, () {
                    setState(() => _bagCount++);
                  }, isAdd: true),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- STEP 2 ---
  Widget _buildStep2ScheduleAndLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DATE & TIME
        _buildSectionTitle("Pickup Date"),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: primaryGreen),
                const SizedBox(width: 15),
                Text(
                  DateFormat('EEE, MMM d').format(_selectedDate),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle("Pickup Time Slot"),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 10,
          ),
          itemCount: _times.length,
          itemBuilder: (context, index) {
            final time = _times[index];
            bool isSelected = _selectedTime == time;
            return GestureDetector(
              onTap: () => setState(() => _selectedTime = time),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? primaryGreen.withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? primaryGreen : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? primaryGreen : Colors.grey[700],
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 30),
        const Divider(thickness: 1),
        const SizedBox(height: 20),

        // LOCATION
        _buildSectionTitle("Pickup Location (Tap map to change)"),
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _sauyoLocation, 
                initialZoom: 15.0, 
                onTap: (tapPosition, point) {
                  setState(() {
                    _sauyoLocation = point; 
                    if (!_sauyoBounds.contains(point)) {
                       _currentAddress = "Unknown Location (Outside Sauyo)";
                    } else {
                       _currentAddress = _demoAddresses[Random().nextInt(_demoAddresses.length)];
                    }
                  });
                },
              ),
              children: [
                TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.waste2wage.app'
                    ),
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: [
                        _sauyoBounds.northWest,
                        _sauyoBounds.northEast,
                        _sauyoBounds.southEast,
                        _sauyoBounds.southWest,
                      ],
                      color: primaryGreen.withValues(alpha: 0.1),
                      borderColor: primaryGreen,
                      borderStrokeWidth: 2,
                      // [FIXED] Removed isFilled: true as it is deprecated/implied by color
                    ),
                  ],
                ),

                MarkerLayer(markers: [
                  Marker(
                      point: _sauyoLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 50))
                ]
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.my_location, color: primaryGreen, size: 28),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Current Location",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                        Text(_currentAddress, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {}, 
                    child: Text("Change", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: "Additional Instructions (Optional)",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                  filled: true,
                  fillColor: bgCream,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- STEP 3 ---
  Widget _buildStep3PaymentAndConfirm() {
    bool isGcashSufficient = _simulatedGcashBalance >= _totalFee;
    bool isEcoPointsSufficient = _simulatedEcoPoints >= _requiredEcoPoints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Payment Method"),
        _buildPaymentOptionCard(
          "GCash",
          isGcashSufficient
              ? "Available Balance: ₱${_simulatedGcashBalance.toStringAsFixed(2)}"
              : "Insufficient Fund (Bal: ₱${_simulatedGcashBalance.toStringAsFixed(2)})",
          Icons.phone_android,
          isDisabled: !isGcashSufficient,
          isError: !isGcashSufficient,
        ),
        _buildPaymentOptionCard("Cash on Pickup", "Pay when hauler arrives", Icons.money),
        _buildPaymentOptionCard(
          "Use Eco-Points", 
          isEcoPointsSufficient
            ? "Available: ${_simulatedEcoPoints.toInt()} EP"
            : "Insufficient (Need $_requiredEcoPoints EP)", 
          Icons.star_outline,
          isDisabled: !isEcoPointsSufficient,
          isError: !isEcoPointsSufficient
        ),

        const SizedBox(height: 25),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Waste is Segregated", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text("Standard +7 EP | Segregated +15 EP", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              Switch(
                value: _isSegregated,
                activeTrackColor: primaryGreen,
                thumbColor: const WidgetStatePropertyAll(Colors.white),
                onChanged: (val) {
                  setState(() => _isSegregated = val);
                  if (val) _showSegregationReminderDialog();
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        _buildDynamicFeeBreakdown(),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _agreedToTerms,
                  activeColor: primaryGreen,
                  onChanged: (val) => setState(() => _agreedToTerms = val!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.black, height: 1.4),
                    children: [
                      const TextSpan(text: "I agree to the terms and conditions\nBy scheduling, you agree to our "),
                      TextSpan(
                          text: "pickup policy",
                          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                      const TextSpan(text: " and "),
                      TextSpan(
                          text: "waste guidelines.",
                          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---
  
  Widget _buildWasteTypeCard(String name, String desc, IconData icon) {
    bool isSelected = _selectedWasteType == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedWasteType = name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isSelected ? Border.all(color: primaryGreen, width: 2) : Border.all(color: Colors.transparent),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? primaryGreen : Colors.grey),
                  color: isSelected ? primaryGreen : Colors.transparent),
              child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionCard(String name, String balance, IconData icon,
      {bool isDisabled = false, bool isError = false}) {
    bool isSelected = _selectedPayment == name;
    Color contentColor = isDisabled ? Colors.grey : Colors.green;
    Color textColor = isDisabled ? Colors.grey : Colors.black;

    return GestureDetector(
      onTap: isDisabled ? null : () => setState(() => _selectedPayment = name),
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: primaryGreen, width: 2)
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: contentColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: contentColor, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                    Text(balance, style: TextStyle(fontSize: 11, color: isError ? Colors.red : Colors.grey)),
                  ],
                ),
              ),
              if (!isDisabled)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? primaryGreen : Colors.white,
                    border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade400),
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicFeeBreakdown() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFFBC02D).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.info_outline, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            const Text("Service Fee Breakdown", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
          ]),
          const SizedBox(height: 15),

          _buildFeeRow("Collection Fee ($_bagCount bags x ₱${_perBagFee.toStringAsFixed(0)})",
              "₱${_totalFee.toStringAsFixed(2)}"),

          const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: Divider(color: Colors.grey)),
          _buildFeeRow("Total Amount", "₱${_totalFee.toStringAsFixed(2)}", isTotal: true),
          
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Points to Earn", style: TextStyle(fontWeight: FontWeight.bold, color: textGreen)),
              Text("+$_pointsToEarn EP", style: TextStyle(fontWeight: FontWeight.bold, color: textGreen, fontSize: 16)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, String amount, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: isTotal ? 16 : 13,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? primaryGreen : Colors.grey[700])),
          Text(amount,
              style: TextStyle(
                  fontSize: isTotal ? 18 : 13,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? primaryGreen : (isTotal ? textGreen : Colors.grey[700]))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)));

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap, {bool isAdd = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: isAdd ? primaryGreen : Colors.grey[200], borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: isAdd ? Colors.white : Colors.black, size: 24),
      ),
    );
  }

  // --- DIALOGS ---

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero, 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF2ECC71), Color(0xFF1EBE71)]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Colors.white.withValues(alpha: 0.3), shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text("Confirm Your Pickup?",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  const Text("Review your details before submitting",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildConfirmRow(
                      "Waste Type", "$_selectedWasteType\n($_bagCount bag${_bagCount > 1 ? 's' : ''})"),
                  const Divider(),
                  _buildConfirmRow(
                      "Date & Time", "${DateFormat('EEE, MMM d').format(_selectedDate)}\n$_selectedTime"),
                  const Divider(),
                  _buildConfirmRow("Location", _currentAddress),
                  const Divider(),
                  _buildConfirmRow("Total Amount", "₱${_totalFee.toStringAsFixed(2)}", isGreen: true),
                  const SizedBox(height: 5),
                  _buildConfirmRow("Points to Earn", "+$_pointsToEarn EP", isGreen: true),
                  
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                              Navigator.pop(context); 
                              _showSuccessDialog();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text("Confirm Pickup",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: isGreen ? primaryGreen : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15))),
        ],
      ),
    );
  }

  void _showSegregationReminderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero, 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration:
                  BoxDecoration(color: Colors.green.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: const Icon(Icons.warning_amber_rounded, size: 50, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Text("Segregation Reminder",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textGreen)),
                  const SizedBox(height: 10),
                  const Text("Please ensure recyclables are properly separated.\nOur hauler will verify upon pickup.",
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: const Color(0xFFC8E6C9), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: textGreen, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text("Properly segregated waste earns you +15 Eco-Points!",
                                style: TextStyle(
                                    color: textGreen, fontSize: 12, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26A69A),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: const Text("Got it, I'm Ready!",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xFF26A69A), borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration:
                    BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text("Pickup Booked!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              const Text("Your request has been confirmed",
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close Dialog
                    Navigator.pop(context); // Return to Home
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: const Text("Go to Home",
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}