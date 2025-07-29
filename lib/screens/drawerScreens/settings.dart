import 'package:MedicalShala/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../logins/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    // Clear all previous context or user data here
    // For example, you can clear shared preferences or any stored session data

    // Navigate to the LoginScreen and remove all previous routes
    // This ensures we completely exit the Navigation widget context
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Remove all previous routes including the Navigation widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: () => _logout(context),
          child: const Text('Logout', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
