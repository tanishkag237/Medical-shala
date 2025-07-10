import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.menu, size: 22, color: Colors.black),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
