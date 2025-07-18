import 'package:flutter/material.dart';

class RoleSelectionDialog extends StatelessWidget {
  const RoleSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Your Role'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _roleOption(
            context,
            icon: Icons.local_hospital,
            role: 'patient',
            label: 'Patient',
          ),
          const SizedBox(height: 16),
          _roleOption(
            context,
            icon: Icons.medical_services,
            role: 'doctor',
            label: 'Doctor',
          ),
        ],
      ),
    );
  }

  Widget _roleOption(BuildContext context, {
    required IconData icon,
    required String role,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: () => Navigator.pop(context, role),
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Colors.blueGrey.shade50,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}
