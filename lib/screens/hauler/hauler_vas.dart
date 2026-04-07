import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the picker
import 'dart:io'; // Required to display the File image

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  int _currentStep = 1;
  
  // File storage variables
  File? _idImage;
  File? _vehicleImage;
  
  final ImagePicker _picker = ImagePicker();

  // Function to pick image
  Future<void> _pickImage(bool isId) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Opens the phone gallery
      imageQuality: 80, // Compresses slightly to save memory
    );

    if (pickedFile != null) {
      setState(() {
        if (isId) {
          _idImage = File(pickedFile.path);
        } else {
          _vehicleImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: _currentStep == 6 ? _buildSuccessView() : _buildStepContent(),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildBackButton(),
        const SizedBox(height: 30),
        const Text("Verify Your Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("Complete the steps below to start hauling", style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 40),

        // --- STEP 1: ID UPLOAD ---
        if (_currentStep == 1) ...[
          const Text("Step 1: Upload Valid ID", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _idImage != null 
            ? _buildPreviewBox(_idImage!, "ID uploaded", () => _pickImage(true)) 
            : _buildUploadPlaceholder("Tap to upload your valid ID", () => _pickImage(true)),
          const SizedBox(height: 30),
          if (_idImage != null) _actionButton("Continue", () => setState(() => _currentStep = 2)),
        ],

        // --- STEP 2: YES/NO VEHICLE ---
        if (_currentStep == 2) ...[
          const Text("Step 2: Do you use vehicle?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _selectionCard(Icons.directions_bike, "Yes", () => setState(() => _currentStep = 3))),
              const SizedBox(width: 20),
              Expanded(child: _selectionCard(Icons.person_outline, "No", () => setState(() => _currentStep = 5))),
            ],
          ),
        ],

        // --- STEP 3: SELECT VEHICLE TYPE ---
        if (_currentStep == 3) ...[
          const Text("Select Vehicle Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _vehicleTile("Bicycle / Pedicab", "Cyclist Hauler - Max 10 Jobs", Icons.directions_bike),
          const SizedBox(height: 15),
          _vehicleTile("Pushcart / Kariton", "Manual Cart Hauler - Max 15 Jobs", Icons.shopping_cart_outlined),
        ],

        // --- STEP 4: UPLOAD VEHICLE PHOTO ---
        if (_currentStep == 4) ...[
          const Text("Upload Vehicle Photo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _vehicleImage != null 
            ? _buildPreviewBox(_vehicleImage!, "Photo Uploaded", () => _pickImage(false)) 
            : _buildUploadPlaceholder("Tap to upload vehicle photo", () => _pickImage(false)),
          const SizedBox(height: 30),
          if (_vehicleImage != null) _actionButton("Submit Verification", () => setState(() => _currentStep = 6)),
        ],

        // --- STEP 5: PEDESTRIAN CATEGORY ---
        if (_currentStep == 5) ...[
           const Text("Step 2: Do you use vehicle?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
           Row(
            children: [
              Expanded(child: _selectionCard(Icons.directions_bike, "Yes", () {}, opacity: 0.3)),
              const SizedBox(width: 20),
              Expanded(child: _selectionCard(Icons.person_outline, "No", () {}, isSelected: true)),
            ],
          ),
          const SizedBox(height: 25),
          _categoryInfoBox("Category: Pedestrian Hauler", "Maximum 5 Jobs per day"),
          const SizedBox(height: 30),
          _actionButton("Submit Verification", () => setState(() => _currentStep = 6)),
        ],
      ],
    );
  }

  // New Helper: Shows the actual image the user picked
  Widget _buildPreviewBox(File imageFile, String label, VoidCallback onRetake) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover),
            border: Border.all(color: const Color(0xFF4CAF50), width: 2),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
            TextButton(onPressed: onRetake, child: const Text("Change Photo", style: TextStyle(color: Colors.blue))),
          ],
        ),
      ],
    );
  }

  // Existing helpers (Keep your previous logic/styles)
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => _currentStep > 1 ? setState(() => _currentStep = 1) : Navigator.pop(context),
      child: const Row(children: [Icon(Icons.arrow_back, color: Colors.grey), SizedBox(width: 8), Text("Back", style: TextStyle(color: Colors.grey, fontSize: 18))]),
    );
  }

  Widget _buildUploadPlaceholder(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            const Icon(Icons.file_upload_outlined, size: 50, color: Colors.grey),
            const SizedBox(height: 15),
            Text(text, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF388E3C), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _selectionCard(IconData icon, String label, VoidCallback onTap, {bool isSelected = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
          ),
          child: Column(
            children: [
              CircleAvatar(backgroundColor: const Color(0xFFDFF6DD), child: Icon(icon, color: Colors.green)),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleTile(String title, String sub, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _currentStep = 4),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: const Color(0xFFDFF6DD), child: Icon(icon, color: Colors.green)),
            const SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ])
          ],
        ),
      ),
    );
  }

  Widget _categoryInfoBox(String title, String sub) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFDFF6DD), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(sub, style: TextStyle(color: Colors.green.shade900)),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pop(context, true);
    });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Color(0xFFDFF6DD), child: Icon(Icons.check, size: 60, color: Color(0xFF4CAF50))),
          const SizedBox(height: 30),
          const Text("Verification Submitted!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text("Redirecting to home...", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}