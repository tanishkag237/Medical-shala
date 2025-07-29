import 'package:flutter/material.dart';
// import 'package:MedicalShala/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
   final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
   Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.008),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
    fontSize: 14, // Smaller label text
    color: Color.fromARGB(255, 71, 69, 69), // Optional: match your theme
  ),
          isDense: true,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 14.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11.0),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}