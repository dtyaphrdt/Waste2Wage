import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'admin_login.dart';
import 'admin_dashboard.dart'; // Added this import

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  String? _selectedZone;
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _barangayController = TextEditingController(text: "Barangay Sauyo");
  final TextEditingController _cityController = TextEditingController(text: "Quezon City");

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  final Color bgCream = const Color(0xFFFFF8F3);
  final Color primaryGreen = const Color(0xFF2ECC71);
  final Color textGreen = const Color(0xFF388E3C);

  final List<String> _zoneOptions = [
    "Area 5-A", "Area 5-B", "Area 6-A", "Area 6-B", "Kapitan", "Valeriana", "Greenville", "Lagkitan", "Old Cabuyaw", "Old Sauyo",
    "Del Mundo", "Gulod", "Banlat", "Chicas", "Dela Nacia", "Hammer", "Herminigildo", "Sunnyville", "99-Godeng", "Rich Land", 
    "Victoria Area", "Abbe Road", "Del Nacia", "Baluyot / Montville Place", "Pingkian", "Lipton St.", "Greenview",
    "Saturnina", "Mabuhay", "135", "Marian", "Angat", "Aplaya", "Ocean Park", "Camiling", "Champaca", "Chesnut",
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _birthdateController.dispose();
    _houseController.dispose();
    _streetController.dispose();
    _barangayController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: bgCream,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: _buildWelcomeText(center: false),
                        ),
                      ),
                      _buildRegisterCard(isDesktop), 
                    ],
                  )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWelcomeText(center: true),
                    const SizedBox(height: 20),
                    Expanded(child: _buildRegisterCard(isDesktop)),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText({bool center = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome!\nLet’s set up\nyour admin\naccount.",
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w800,
            color: textGreen,
            height: 1.0,
          ),
          textAlign: center ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 20),
        Text(
          "Join Waste2Wage waste management system",
          style: TextStyle(fontSize: 22, color: Colors.grey[700], height: 1.5, fontWeight: FontWeight.w500),
          textAlign: center ? TextAlign.center : TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildRegisterCard(bool isDesktop) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(maxHeight: isDesktop ? screenHeight * 0.75 : screenHeight * 0.8, maxWidth: 550),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(primaryGreen.withOpacity(0.3)),
            ),
          ),
        child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(          
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create Admin Account",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textGreen),
                ),
                const SizedBox(height: 30),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildFieldLabel("First Name"),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: _inputDecoration("Juan", Icons.person_outline),
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                            validator: (val) => (val == null || val.length < 2) ? 'Too short' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _buildFieldLabel("Last Name"),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: _inputDecoration("Dela Cruz", Icons.person_outline),
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                            validator: (val) => (val == null || val.length < 2) ? 'Too short' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildFieldLabel("Date of Birth"),
                TextFormField(
                  controller: _birthdateController,
                  readOnly: true,
                  decoration: _inputDecoration("YYYY-MM-DD", Icons.calendar_month_outlined),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2005),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() => _birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate));
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    try {
                      DateTime birthDate = DateFormat('yyyy-MM-dd').parse(value);
                      DateTime today = DateTime.now();
                      int age = today.year - birthDate.year;
                      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
                        age--;
                      }
                      if (age < 18) return 'Must be 18+ years old';
                    } catch (e) {
                      return 'Invalid date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildFieldLabel("Email Address"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("you@example.com", Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildFieldLabel("Contact Number"),
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _PhSuffixFormatter(),
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: _inputDecoration("XX-XXX-XXXX", Icons.phone_outlined).copyWith(prefixText: "09 "),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    String cleanVal = value.replaceAll('-', '');
                    if (cleanVal.length != 9) return 'Enter valid suffix';
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textGreen)),
                ),
                const Divider(height: 30),

                _buildFieldLabel("Zone / Area"),
                DropdownButtonFormField<String>(
                  value: _selectedZone,
                  items: _zoneOptions.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(),
                  onChanged: (val) => setState(() => _selectedZone = val),
                  decoration: _inputDecoration("Select your Area", Icons.map_outlined),
                  validator: (val) => val == null ? "Required" : null,
                ),
                const SizedBox(height: 20),

                _buildFieldLabel("House / Lot / Block No."),
                TextFormField(
                  controller: _houseController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: _inputDecoration("Blk 12 Lot 5, #123", Icons.home_outlined),
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),

                _buildFieldLabel("Street Name"),
                TextFormField(
                  controller: _streetController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration("Don Julio Gregorio", Icons.add_road_outlined),
                  validator: (val) => val!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildFieldLabel("Barangay"),
                          TextFormField(controller: _barangayController, readOnly: true, decoration: _inputDecoration("", Icons.location_city).copyWith(fillColor: Colors.grey[100])),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _buildFieldLabel("City"),
                          TextFormField(controller: _cityController, readOnly: true, decoration: _inputDecoration("", Icons.apartment).copyWith(fillColor: Colors.grey[100])),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                _buildFieldLabel("Create Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _inputDecoration("Create a strong password", Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 8) return 'Min 8 chars';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                _buildFieldLabel("Confirm Password"),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: _inputDecoration("Confirm your password", Icons.check_circle_outline).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey),
                      onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                  ),
                  validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null,
                ),

                const SizedBox(height: 20),
                CheckboxListTile(
                  value: _agreedToTerms,
                  activeColor: primaryGreen,
                  onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                  title: const Text("I agree to the Terms & Conditions", style: TextStyle(fontSize: 13)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_agreedToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please agree to the Terms & Conditions.")));
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        // Successfully connected to AdminDashboard
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminDashboard()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ", style: TextStyle(fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginScreen())),
                      child: Text("Log in", style: TextStyle(fontSize: 13, color: primaryGreen, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
    )
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textGreen)),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryGreen, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _PhSuffixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 9) text = text.substring(0, 9);
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
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