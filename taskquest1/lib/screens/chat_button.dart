// lib/components/chat_button.dart
import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ChatButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chat_bubble_outline, color: Colors.teal),
      onPressed: onPressed,
    );
  }
}
void showTaskAssistant(BuildContext context) {
  final TextEditingController _chatController = TextEditingController();
  List<String> chatHistory = [];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40), // <-- Add this line to push the title downward
                Text('Task Assistant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: chatHistory
                        .map((msg) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(msg),
                    ))
                        .toList(),
                  ),
                ),
                TextField(
                  controller: _chatController,
                  decoration: InputDecoration(
                    hintText: 'What’s your task?',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (text) {
                    setState(() {
                      chatHistory.add('You: $text');
                      chatHistory.add('Assistant: Try breaking it into 3 steps...');
                      _chatController.clear();
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
