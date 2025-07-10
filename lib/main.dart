import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/Navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedShala',
      home: const Navigation(),
       theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}