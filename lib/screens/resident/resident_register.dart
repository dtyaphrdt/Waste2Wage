import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; 
import 'resident_login.dart';

class ResidentRegisterScreen extends StatefulWidget {
  const ResidentRegisterScreen({super.key});

  @override
  State<ResidentRegisterScreen> createState() => _ResidentRegisterScreenState();
}

class _ResidentRegisterScreenState extends State<ResidentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- CONTROLLERS ---
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
    final Color bgCream = const Color(0xFFFFF8F3);
    final Color primaryGreen = const Color(0xFF388E3C);
    final Color decorationGreen = const Color(0xFFD6F3D7);

    return Scaffold(
      backgroundColor: bgCream,
      body: Stack(
        children: [
          Positioned(
            top: 100, left: -80,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(color: decorationGreen, shape: BoxShape.circle),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                // [FIX 2] Changed from onUserInteraction to disabled to stop aggressive validation
                autovalidateMode: AutovalidateMode.disabled, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Create Account",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Join our community to easily schedule\npickups and keep your home clutter-free.",
                      style: TextStyle(fontSize: 14, color: primaryGreen.withValues(alpha: 0.8)),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    // --- 1. NAME SECTION ---
                    Row(
                      // [FIX 1] Align to top so error text doesn't push fields out of alignment
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("First Name"),
                              _buildTextFormField(
                                controller: _firstNameController,
                                hint: "Juan",
                                icon: Icons.person_outline,
                                capitalization: TextCapitalization.words,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                                // [FIX 3] Check empty first for "Required" logic
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Required';
                                  if (val.length < 2) return 'Too short';
                                  return null;
                                },
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
                                hint: "Dela Cruz",
                                icon: Icons.person_outline,
                                capitalization: TextCapitalization.words,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                                // [FIX 3] Check empty first for "Required" logic
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Required';
                                  if (val.length < 2) return 'Too short';
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    _buildLabel("Date of Birth"),
                    TextFormField(
                      controller: _birthdateController,
                      readOnly: true,
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
                          context: context,
                          initialDate: DateTime(2005), 
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(primary: primaryGreen, onPrimary: Colors.white, onSurface: primaryGreen),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _birthdateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                      style: const TextStyle(fontSize: 14),
                      decoration: _getInputDecoration(hint: "YYYY-MM-DD", icon: Icons.calendar_month_outlined),
                    ),

                    const SizedBox(height: 15),

                    _buildLabel("Email Address"),
                    _buildTextFormField(
                      controller: _emailController,
                      hint: "you@example.com",
                      icon: Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                      validator: (value) {
                        // [FIX 4] Required specific string
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    _buildLabel("Contact Number"),
                    _buildTextFormField(
                      controller: _contactController,
                      hint: "XX-XXX-XXXX",
                      icon: Icons.phone_outlined,
                      inputType: TextInputType.number,
                      prefixText: "09 ", 
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _PhSuffixFormatter(),
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        String cleanVal = value.replaceAll('-', '');
                        if (cleanVal.length != 9) return 'Enter 11 digit number';
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),
                    Text("Address", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryGreen)),
                    const SizedBox(height: 15),

                    _buildLabel("Zone / Area"),
                    _buildDropdownField(
                      value: _selectedZone,
                      hint: "Select your Area",
                      items: _zoneOptions,
                      onChanged: (val) => setState(() => _selectedZone = val),
                      validator: (val) => val == null ? "Required" : null,
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("House / Lot / Block No."),
                    _buildTextFormField(
                      controller: _houseController,
                      hint: "Blk 12 Lot 5, #123",
                      icon: Icons.home_outlined,
                      capitalization: TextCapitalization.characters,
                      validator: (val) => val!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Street Name"),
                    _buildTextFormField(
                      controller: _streetController,
                      hint: "Don Julio Gregorio",
                      icon: Icons.add_road_outlined,
                      capitalization: TextCapitalization.words,
                      validator: (val) => val!.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("Barangay"), _buildTextFormField(controller: _barangayController, hint: "", readOnly: true, fillColor: Colors.grey)]),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("City"), _buildTextFormField(controller: _cityController, hint: "", readOnly: true, fillColor: Colors.grey)]),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    _buildLabel("Create Password"),
                    _buildPasswordFormField(
                      controller: _passwordController,
                      hint: "Create a strong password",
                      isVisible: _isPasswordVisible,
                      toggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (value.length < 8) return 'Min 8 chars';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Confirm Password"),
                    _buildPasswordFormField(
                      controller: _confirmPasswordController,
                      hint: "Confirm your password",
                      isVisible: _isConfirmPasswordVisible,
                      isConfirm: true,
                      toggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            activeColor: primaryGreen,
                            onChanged: (val) => setState(() => _agreedToTerms = val!),
                          ),
                          Expanded(
                            child: Wrap(
                              children: [
                                Text("I agree to the ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text("Terms & Condition", style: TextStyle(fontSize: 12, color: primaryGreen, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                                Text(" and ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text("Privacy Policy", style: TextStyle(fontSize: 12, color: primaryGreen, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // REGISTER BUTTON
                    ElevatedButton(
                      onPressed: () async {
                        if (!_agreedToTerms) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please agree to the Terms & Conditions."), backgroundColor: Colors.red));
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processing Registration..."), backgroundColor: Colors.green));
                          
                          // [FIX 5] Logic to prevent hanging: Wait and then Redirect
                          await Future.delayed(const Duration(seconds: 2));
                          if (mounted) {
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => const ResidentLoginScreen())
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                      ),
                      child: const Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ", style: TextStyle(fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ResidentLoginScreen())),
                          child: Text("Log in", style: TextStyle(fontSize: 13, color: primaryGreen, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---
  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 5, left: 2), child: Text(text, style: const TextStyle(color: Color(0xFF388E3C), fontWeight: FontWeight.w600, fontSize: 13)));

  // Shared Decoration to keep UI consistent
  InputDecoration _getInputDecoration({required String hint, IconData? icon, String? prefixText, Color? fillColor}) {
    return InputDecoration(
      hintText: hint, hintStyle: TextStyle(color: Colors.grey, fontSize: 14), 
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey, size: 20) : null, 
      counterText: "", filled: true, fillColor: fillColor ?? Colors.white,
      prefixText: prefixText, prefixStyle: const TextStyle(color: Colors.black87, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF388E3C), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF388E3C), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 1)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller, 
    required String hint, 
    IconData? icon, 
    String? Function(String?)? validator, 
    TextInputType inputType = TextInputType.text, 
    List<TextInputFormatter>? inputFormatters, 
    int? maxLength, 
    TextCapitalization capitalization = TextCapitalization.none, 
    bool readOnly = false, 
    Color? fillColor,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller, keyboardType: inputType, inputFormatters: inputFormatters, validator: validator, maxLength: maxLength, textCapitalization: capitalization, readOnly: readOnly,
      style: const TextStyle(fontSize: 14),
      decoration: _getInputDecoration(hint: hint, icon: icon, prefixText: prefixText, fillColor: fillColor),
    );
  }

  Widget _buildDropdownField({required String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged, required String? Function(String?) validator}) {
    return DropdownButtonFormField<String>(
      value: value, items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(), onChanged: onChanged, validator: validator, menuMaxHeight: 300, borderRadius: BorderRadius.circular(10), dropdownColor: Colors.white,
      decoration: _getInputDecoration(hint: hint, icon: Icons.map_outlined),
    );
  }

  Widget _buildPasswordFormField({required TextEditingController controller, required String hint, required bool isVisible, required VoidCallback toggleVisibility, String? Function(String?)? validator, bool isConfirm = false}) {
    return TextFormField(
      controller: controller, obscureText: !isVisible, validator: validator, style: const TextStyle(fontSize: 14),
      decoration: _getInputDecoration(hint: hint, icon: isConfirm ? Icons.check_circle_outline : Icons.lock_outline).copyWith(
        suffixIcon: IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey), onPressed: toggleVisibility),
      ),
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
    return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}