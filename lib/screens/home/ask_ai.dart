import 'package:flutter/material.dart';
import 'package:medshala/theme/app_colors.dart';

import '../../models/chat_message.dart';
import '../../services/gemini_service.dart';
import '../../widgets/app_drawer.dart';


class AskAIScreen extends StatefulWidget {
  @override
  _AskAIScreenState createState() => _AskAIScreenState();
}

class _AskAIScreenState extends State<AskAIScreen> {
  final TextEditingController queryController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool isLoading = false;

  void sendMessage() async {
    final userText = queryController.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userText, sender: Sender.user));
      isLoading = true;
      queryController.clear();
    });

    try {
      final aiResponse = await GeminiService.getFlashResponse(userText);
      setState(() {
        _messages.add(ChatMessage(text: aiResponse, sender: Sender.ai));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: '❌ Error: $e', sender: Sender.ai));
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.sender == Sender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar:  AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black), // Ensure the menu icon is visible
            title: Text("Ask AI",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu), // Menu icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the drawer
                  },
                );
              },
            ),
          ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_messages[index]);
              },
            ),
          ),
          // if (isLoading) Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CircularProgressIndicator(),
          // ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: queryController,
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: isLoading ? null : sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
