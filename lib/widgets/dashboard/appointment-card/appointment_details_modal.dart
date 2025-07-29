import 'package:flutter/material.dart';
import '../../../../models/appointment_firebase_model.dart';
import 'appointment_status_helper.dart';

class AppointmentDetailsModal {
  static void show(BuildContext context, AppointmentFirebaseModel appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'Appointment Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Details
                _buildDetailRow('Patient Name', appointment.patientName),
                _buildDetailRow('Age', '${appointment.age} years'),
                _buildDetailRow('Gender', appointment.gender),
                _buildDetailRow('Doctor', 'Dr. ${appointment.doctorName}'),
                _buildDetailRow('Hospital', appointment.hospitalName),
                _buildDetailRow('Date', appointment.date),
                _buildDetailRow('Time Slot', '${appointment.slot} (${AppointmentStatusHelper.getFormattedTime(appointment)})'),
                _buildDetailRow('Scheduled Time', AppointmentStatusHelper.getRelativeTimeInfo(appointment).isNotEmpty ? AppointmentStatusHelper.getRelativeTimeInfo(appointment) : 'Unknown'),
                _buildDetailRow('Contact', appointment.contact),
                _buildDetailRow('Status', '${appointment.status.toUpperCase()} → ${AppointmentStatusHelper.getAppointmentStatus(appointment)['status']}'),
                if (appointment.reason.isNotEmpty)
                  _buildDetailRow('Reason', appointment.reason, isLast: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
