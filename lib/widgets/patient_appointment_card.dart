import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart';

class PatientAppointmentCard extends StatelessWidget {
  final PatientModel appointment;

  const PatientAppointmentCard({
    super.key,
    required this.appointment,
  });

  // Utility to get status and its color based on time
  Map<String, dynamic> getAppointmentStatus() {
    final now = DateTime.now();
    final diff = appointment.appointmentTime.difference(now);

    if (diff.inMinutes.abs() <= 15) {
      return {"status": "ONGOING", "color": Colors.green};
    } else if (appointment.appointmentTime.isAfter(now)) {
      return {"status": "UPCOMING", "color": Colors.blue};
    } else {
      return {"status": "MISSED", "color": Colors.red};
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusInfo = getAppointmentStatus();

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8 , horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade300)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                appointment.imagePath,
                width: size.width * 0.25,
                height: size.width * 0.25,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            SizedBox(width: size.width * 0.05),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time + Status
                  Text(
                    "${DateFormat('hh:mm a').format(appointment.appointmentTime)} • ${statusInfo['status']}",
                    style: TextStyle(
                      color: statusInfo['color'],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Name
                  Text(
                    appointment.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // Inline details
                  Wrap(
                    spacing: size.width * 0.02,
                    runSpacing: size.width * 0.01,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline, size: size.width * 0.025, color: Colors.grey),
                          SizedBox(width: size.width * 0.01),
                          Text("${appointment.id}", style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.025)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_2_outlined, size: size.width * 0.025, color: Colors.grey),
                          SizedBox(width: size.width * 0.01),
                          Text("${appointment.age}, ${appointment.gender}", style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.025)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer_outlined, size: size.width * 0.025, color: Colors.grey),
                          SizedBox(width: size.width * 0.01),
                          Text("Visited ${appointment.lastVisited}", style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.025)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),

            const Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}