import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'resident_profile.dart'; 
import 'resident_change_password.dart'; 

class ResidentEditProfileScreen extends StatefulWidget {
  const ResidentEditProfileScreen({super.key});

  @override
  State<ResidentEditProfileScreen> createState() => _ResidentEditProfileScreenState();
}

class _ResidentEditProfileScreenState extends State<ResidentEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // --- CONTROLLERS ---
  final TextEditingController _firstNameController = TextEditingController(text: "Maria");
  final TextEditingController _lastNameController = TextEditingController(text: "Santos");
  final TextEditingController _birthdateController = TextEditingController(text: "1999-05-20");
  final TextEditingController _emailController = TextEditingController(text: "mariasantos@gmail.com");
  
  // [UPDATED] Controller only holds the digits AFTER 09 (e.g. 12-345-6789)
  final TextEditingController _phoneController = TextEditingController(text: "12-345-6789"); 
  
  // Address Controllers
  final TextEditingController _houseNoController = TextEditingController(text: "Blk 12 Lot 5, #123");
  final TextEditingController _streetController = TextEditingController(text: "Don Julio Gregorio");
  
  String? _selectedZone = "Zone 1"; 
  final List<String> _zones = [
    "Zone 1", "Zone 2", "Zone 3", "Area A", "Area B", 
    "Area 5", "Area 6-A", "Area 6-V", "Hammer", "Green Fields 1"
  ];

  // --- COLORS ---
  final Color bgCream = const Color(0xFFFFF8F3);
  final Color headerGreen = const Color(0xFFDFF6DD);
  final Color textGreen = const Color(0xFF388E3C);
  final Color primaryGreen = const Color(0xFF2ECC71);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCream,
      body: Column(
        children: [
          // HEADER
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentProfileScreen()));
                  },
                  icon: Icon(Icons.arrow_back, color: textGreen, size: 28), padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 15),
                Text("Edit Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textGreen)),
              ],
            ),
          ),

          // FORM
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(25),
                physics: const BouncingScrollPhysics(),
                children: [
                  // AVATAR
                  Center(
                    child: Stack(
                      children: [
                        Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: primaryGreen, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))]), child: const Icon(Icons.person, size: 60, color: Colors.white)),
                        Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: primaryGreen, width: 2)), child: Icon(Icons.camera_alt, color: primaryGreen, size: 16))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(child: TextButton(onPressed: () {}, child: Text("Change Profile", style: TextStyle(color: textGreen, fontWeight: FontWeight.bold)))),

                  const SizedBox(height: 20),

                  // --- 1. FIRST NAME & LAST NAME ---
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("First Name"),
                            _buildTextFormField(
                              controller: _firstNameController, 
                              icon: Icons.person_outline, 
                              hint: "Juan",
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))], // No numbers
                              validator: (val) => val!.isEmpty ? "Required" : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Last Name"),
                            _buildTextFormField(
                              controller: _lastNameController, 
                              icon: Icons.person_outline, 
                              hint: "Dela Cruz",
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))], // No numbers
                              validator: (val) => val!.isEmpty ? "Required" : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),

                  // --- 2. DATE OF BIRTH ---
                  _buildLabel("Date of Birth"),
                  TextFormField(
                    controller: _birthdateController,
                    readOnly: true,
                    // [UPDATED] onUserInteraction validates immediately when a date is picked
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      DateTime birthDate = DateFormat('yyyy-MM-dd').parse(value);
                      DateTime today = DateTime.now();
                      int age = today.year - birthDate.year;
                      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
                        age--;
                      }
                      if (age < 18) return 'Must be 18+ years old';
                      return null;
                    },
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context, initialDate: DateTime(1999, 5, 20), firstDate: DateTime(1900), lastDate: DateTime.now(),
                        builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: primaryGreen, onPrimary: Colors.white, onSurface: textGreen)), child: child!),
                      );
                      if (pickedDate != null) {
                        // This updates the text, triggering immediate validation
                        setState(() => _birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate));
                      }
                    },
                    decoration: InputDecoration(prefixIcon: Icon(Icons.calendar_month_outlined, color: Colors.grey[500], size: 20), hintText: "YYYY-MM-DD", hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13), filled: true, fillColor: Colors.white, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textGreen, width: 1)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textGreen, width: 2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15)), style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 15),

                  // --- 3. CONTACT NUMBER (09 Fixed) ---
                  _buildLabel("Contact Number"),
                  _buildTextFormField(
                    controller: _phoneController, 
                    // [UPDATED] Prefix Text "09" - User cannot delete this
                    prefixText: "09 ", 
                    icon: Icons.phone_outlined, 
                    hint: "XX-XXX-XXXX", 
                    keyboardType: TextInputType.number, 
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, 
                      _PhSuffixFormatter(), // Custom formatter for the remaining digits
                      LengthLimitingTextInputFormatter(11), // Limit: 9 digits + 2 hyphens
                    ],
                    validator: (val) {
                      if (val == null || val.isEmpty) return "Required";
                      // Only check the digits entered by user (should be 9)
                      String cleanVal = val.replaceAll('-', '');
                      if (cleanVal.length != 9) return "Enter 9 digits";
                      return null;
                    }
                  ),

                  const SizedBox(height: 15),

                  // --- 4. EMAIL ---
                  _buildLabel("Email Address"),
                  _buildTextFormField(controller: _emailController, icon: Icons.email_outlined, hint: "Enter Email Address", validator: (val) => val!.contains("@") ? null : "Invalid Email"),
                  
                  const SizedBox(height: 25),

                  // --- ADDRESS SECTION ---
                  Row(children: [Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textGreen)), const SizedBox(width: 10), Expanded(child: Container(height: 1, color: textGreen.withValues(alpha: 0.3)))]),
                  const SizedBox(height: 15),

                  _buildLabel("Zone / Area"),
                  _buildDropdownField(hint: "Select your Area", value: _selectedZone, items: _zones, onChanged: (val) => setState(() => _selectedZone = val)),
                  const SizedBox(height: 15),

                  _buildLabel("House / Lot / Block No."),
                  _buildTextFormField(controller: _houseNoController, icon: Icons.home_outlined, hint: "Blk 12 Lot 5, #123", validator: (val) => val!.isEmpty ? "Required" : null),
                  const SizedBox(height: 15),

                  _buildLabel("Street Name"),
                  _buildTextFormField(controller: _streetController, icon: Icons.edit_road, hint: "Don Julio Gregorio", validator: (val) => val!.isEmpty ? "Required" : null),
                  const SizedBox(height: 15),

                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Barangay"), _buildReadOnlyField("Barangay Sauyo")])),
                    const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("City"), _buildReadOnlyField("Quezon City")])),
                  ]),

                  const SizedBox(height: 20),

                  Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentChangePasswordScreen())); }, child: Text("Change Password?", style: TextStyle(color: textGreen, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: textGreen)))),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated!")));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentProfileScreen()));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5),
                      child: const Text("Save Changes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textGreen)),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller, 
    required IconData icon, 
    required String hint,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText, // [UPDATED] Added prefixText parameter
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
        // [UPDATED] Renders the "09" text permanently inside the field
        prefixText: prefixText, 
        prefixStyle: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.normal),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textGreen, width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textGreen, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildDropdownField({required String hint, required String? value, required List<String> items, required void Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      initialValue: value, items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(), onChanged: onChanged,
      decoration: InputDecoration(prefixIcon: Icon(Icons.map_outlined, color: Colors.grey[500], size: 20), hintText: hint, hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13), filled: true, fillColor: Colors.white, enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textGreen, width: 1)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textGreen, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
    );
  }

  Widget _buildReadOnlyField(String text) {
    return Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400)), child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)));
  }
}

// --- CUSTOM FORMATTER FOR SUFFIX (XX-XXX-XXXX) ---
// Since "09" is already in the UI, this formats the remaining 9 digits
class _PhSuffixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll('-', ''); // Remove existing hyphens
    if (text.length > 9) return oldValue; // Limit to 9 digits (since 09 is separate)

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // Add hyphen after 2nd digit (12-) and 5th digit (12-345-)
      if ((i == 1 || i == 4) && i != text.length - 1) {
        buffer.write('-');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}