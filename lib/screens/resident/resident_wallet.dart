import 'package:flutter/material.dart';
import 'resident_home.dart';

void main() {
  runApp(const MaterialApp(
    home: WalletScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Controller for the amount input
  final TextEditingController _amountController = TextEditingController(text: "0.00");
  
  // NEW: Added a variable to track the actual balance
  double _currentBalance = 1125.00;

  final List<Map<String, dynamic>> _transactions = [
    {"title": "Gcash Cash In", "date": "Today", "amount": 100.00, "isIncome": true},
    {"title": "Cancelled Pickup Refund", "date": "Yesterday", "amount": 80.00, "isIncome": true},
    {"title": "Pickup Payment", "date": "Yesterday", "amount": 120.00, "isIncome": false},
    {"title": "Pickup Payment", "date": "Feb 10", "amount": 100.00, "isIncome": false},
    {"title": "Gcash Cash In", "date": "Feb 10", "amount": 500.00, "isIncome": true},
  ];

  final List<String> _presets = ["50", "100", "200", "500", "1000"];
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);

  @override
  void dispose() {
    _amountController.dispose(); // Prevents memory leaks
    super.dispose();
  }

  void _showCashInSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to expand for the keyboard
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cash In", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text("Add money to your wallet", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined, size: 30),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Amount Input
                  const Text("Enter Amount", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("₱", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE0E0E0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Preset Chips
                  Wrap(
                    spacing: 8,
                    children: _presets.map((amount) => ActionChip(
                          label: Text("₱$amount"),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            setModalState(() => _amountController.text = "$amount.00");
                          },
                        )).toList(),
                  ),

                  const SizedBox(height: 30),
                  const Text("Select Payment Method", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),

                  // GCash Selection (Visual Only)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: const Icon(Icons.smartphone, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 10),
                        const Text("GCash", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Continue Button with Validation
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2CB882),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        final amountText = _amountController.text.replaceAll('₱', '').trim();
                        final val = double.tryParse(amountText) ?? 0;

                        if (val <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a valid amount")),
                          );
                        } else {
                          // FUNCTIONALITY ADDED HERE:
                          setState(() {
                            // Update Balance
                            _currentBalance += val;
                            // Add to Transaction History
                            _transactions.insert(0, {
                              "title": "Gcash Cash In",
                              "date": "Today",
                              "amount": val,
                              "isIncome": true
                            });
                          });

                          // 1. Close the Bottom Sheet
                          Navigator.pop(context);

                          // 2. Show the Success Notification
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.black, size: 32),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Cash-in successful!",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            "₱${val.toStringAsFixed(2)} has been added to your wallet.",
                                            style: const TextStyle(color: Colors.black87, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          decoration: BoxDecoration(
            color: headerGreen,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ResidentHomeScreen()),
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.green, size: 28),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 15),
              const Text(
                "Wallet",
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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildBalanceCard(),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2CB882), Color(0xFF1EBE71)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1EBE71).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _showCashInSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "+ Cash In",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 15),
                ..._transactions.map((tx) => _buildTransactionTile(tx)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF42E695), Color(0xFF146944)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Icon(Icons.account_balance_wallet_outlined, color: Colors.white70),
              SizedBox(width: 8),
              Text("Available Balance", style: TextStyle(color: Colors.white70, fontSize: 16))
            ]),
            // Updated to use the variable
            Text("₱ ${_currentBalance.toStringAsFixed(2)}", 
                 style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
            const Text("Used for trash pickup payments", style: TextStyle(color: Colors.white54, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

Widget _buildTransactionTile(Map<String, dynamic> tx) {
  bool isIncome = tx['isIncome'];
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isIncome ? const Color(0xFFE2F3D1) : const Color(0xFFFFEBEE),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? Icons.north_east : Icons.south_west,
            color: isIncome ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx['title'],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                tx['date'],
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        Text(
          "${isIncome ? '+' : '-'}₱${tx['amount'].toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isIncome ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}