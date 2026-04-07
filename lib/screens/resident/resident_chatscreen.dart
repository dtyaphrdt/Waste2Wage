import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // 2. Required for File

// Update the model to support images
class ChatMessage {
  final String? text;
  final String? imagePath; // New field
  final String time;
  final bool isMe;

  ChatMessage({this.text, this.imagePath, required this.time, required this.isMe});
}

class ResidentChatscreen extends StatefulWidget {
  const ResidentChatscreen({super.key});

  @override
  State<ResidentChatscreen> createState() => _ResidentChatscreenState();
}

class _ResidentChatscreenState extends State<ResidentChatscreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // 3. Initialize Picker
  
  final List<ChatMessage> _messages = [
ChatMessage(text: "Hi! I've accepted your pickup. I'll be there in about 15 minutes.", time: "9:27 PM", isMe: false),
    ChatMessage(text: "Great, thanks! The trash bag are by the garage door.", time: "9:30 PM", isMe: true),
    ChatMessage(text: "Perfect, I'll look for them there. Is there anything fragile or heavy I should know about?", time: "9:33 PM", isMe: false),
    ChatMessage(text: "Just some cardboard boxes and plastic recyclables. Nothing too heavy!", time: "9:35 PM", isMe: true),
    ChatMessage(text: "On my way now! Should arrive in 5 minutes.", time: "9:50 PM", isMe: false),];

  // 4. Function to pick image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _messages.add(
          ChatMessage(
            imagePath: pickedFile.path,
            time: TimeOfDay.now().format(context),
            isMe: true,
          ),
        );
      });
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(
        text: _controller.text,
        time: TimeOfDay.now().format(context),
        isMe: true,
      ));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    const Color bgCream = Color(0xFFFFF8F3);
    const Color brandGreen = Color(0xFF388E3C);
    // ... (Keep your existing Scaffold and AppBar) ...
    // Update the IconButton in the Input Area:
    // IconButton(onPressed: _pickImage, icon: const Icon(Icons.image_outlined, color: Colors.grey)),
    
    // Update the _buildChatBubble to handle images:
    return Scaffold(
    appBar: AppBar(
        backgroundColor: bgCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: brandGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green[100],
              child: const Text("EP", style: TextStyle(color: brandGreen, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Juan Santos", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                Text("• On the way", style: TextStyle(color: Colors.orange, fontSize: 12)),
              ],
            ),
            ],
            ),
          ),   
          body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildChatBubble(_messages[index]),
              ),
            ),
            _buildInputArea(),
          ],
        ),
    );
  }

  Widget _buildInputArea() {
     return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _pickImage, // 5. Connect the function
              icon: const Icon(Icons.image_outlined, color: Colors.grey),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: "Type your message...", border: InputBorder.none),
                ),
              ),
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              backgroundColor: const Color(0xFF388E3C),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Column(
      crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: msg.imagePath != null ? const EdgeInsets.all(5) : const EdgeInsets.all(15),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: msg.isMe ? const Color(0xFF388E3C) : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: msg.imagePath != null 
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(msg.imagePath!), fit: BoxFit.cover),
              )
            : Text(msg.text ?? "", style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87)),
        ),
        Text(msg.time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 10),
      ],
    );
  }
}