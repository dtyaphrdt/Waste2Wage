import 'package:flutter/material.dart';
import 'resident_help&support.dart';

class FaqItem {
  String question;
  Widget answerContent;
  bool isExpanded;

  FaqItem({
    required this.question,
    required this.answerContent,
    this.isExpanded = false,
  });
}

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);

  late final List<FaqItem> _faqsList;

  @override
  void initState() {
    super.initState();
    _faqsList = _generateFaqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: Column(
        children: [
          // HEADER - Flat design as per image
          Container(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: headerGreen,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
                  }, 
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("FAQs", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                Text(
                  "Find answers to frequently asked questions about Waste2Wage.",
                  style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 30),

                // THE MAIN FAQ CONTAINER
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _buildExpansionPanelList(),
                  ),
                ),
                
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionPanelList() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey.shade300, // Matches the thin lines between questions
      ),
      child: ExpansionPanelList(
        elevation: 0, 
        expandedHeaderPadding: EdgeInsets.zero,
        animationDuration: const Duration(milliseconds: 300),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _faqsList[index].isExpanded = isExpanded;
          });
        },
        children: _faqsList.asMap().entries.map<ExpansionPanel>((entry) {
          final FaqItem faq = entry.value;

          return ExpansionPanel(
            backgroundColor: Colors.white,
            isExpanded: faq.isExpanded,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  faq.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              );
            },
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                child: faq.answerContent,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<FaqItem> _generateFaqs() {
    return [
      FaqItem(
        question: "How do I book a waste pickup?",
        answerContent: const Text("Open the app, select Pa-Hakot, set your location, choose your schedule, and confirm your booking."),
      ),
      FaqItem(
        question: "How much does a pickup cost?",
        answerContent: const Text("The standard rate is around ₱20 per sack, depending on the service and availability of haulers."),
      ),
      FaqItem(
        question: "Can I track my hauler?",
        answerContent: const Text("Yes, you can track your assigned hauler in real time using the in-app map."),
      ),
      FaqItem(
        question: "What are Eco-Points?",
        answerContent: const Text("Eco-Points are rewards you earn for every completed pickup and proper waste segregation."),
      ),
      FaqItem(
        question: "How do I earn more Eco-Points?",
        answerContent: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("You can earn:"),
            SizedBox(height: 5),
            Text("•  7 points for regular pickups"),
            Text("•  15 points for segregated waste"),
            Text("•  Bonus points for consistency and referrals"),
          ],
        ),
      ),
      FaqItem(
        question: "How can I use my Eco-Points?",
        answerContent: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Eco-Points can be redeemed for:"),
            SizedBox(height: 5),
            Text("•  Free Pa-Hakot vouchers"),
            Text("•  Free waste pickup rewards"),
          ],
        ),
      ),
      FaqItem(
        question: "What if my pickup is missed or delayed?",
        answerContent: const Text("You can contact support through the app or report the issue in the Help & Support section."),
      ),
      FaqItem(
        question: "Can I cancel my booking?",
        answerContent: const Text("Yes, you can cancel your booking within the allowed time before the scheduled pickup."),
      ),
      FaqItem(
        question: "Is my personal information safe?",
        answerContent: const Text("Yes, your data is protected and only shared with your assigned hauler during confirmed bookings."),
      ),
      FaqItem(
        question: "What if I input the wrong location?",
        answerContent: const Text("You can update your location before confirming your booking to ensure accurate pickup."),
      ),
    ];
  }
}