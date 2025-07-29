import 'package:flutter/material.dart';
import '../../../../models/appointment_firebase_model.dart';

class AppointmentActions {
  static void handleCancel(BuildContext context, AppointmentFirebaseModel appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showCancellationSuccess(context);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  static void _showCancellationSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment cancelled successfully'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Future: Add more appointment actions here
  // static void handleReschedule(BuildContext context, AppointmentFirebaseModel appointment) {}
  // static void handleComplete(BuildContext context, AppointmentFirebaseModel appointment) {}
}
