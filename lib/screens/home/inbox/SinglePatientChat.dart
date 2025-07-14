import 'package:flutter/material.dart';
import 'package:medshala/theme/app_colors.dart';

class Singlepatientchat extends StatefulWidget {
  final String name;
  
  const Singlepatientchat({super.key, required this.name});

  @override
  State<Singlepatientchat> createState() => _SinglepatientchatState();
}

class _SinglepatientchatState extends State<Singlepatientchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.name}',
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          'Chat with ${widget.name}',
          style: const TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the button
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}