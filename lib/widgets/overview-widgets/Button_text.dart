import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onPressed;
  final double horizontalPadding;
  final double verticalPadding;

  const ButtonText({
    super.key,
    this.icon,
    required this.label,
    this.onPressed,
    this.horizontalPadding = 18,
    this.verticalPadding = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0078D4),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center, // Align content in the center
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min, // Ensure content is centered
          mainAxisAlignment: MainAxisAlignment.center, // Align content horizontally
          children: [
            if (icon != null) Icon(icon, size: 20), // Add icon if provided
            if (icon != null) const SizedBox(width: 8), // Add spacing between icon and label
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}