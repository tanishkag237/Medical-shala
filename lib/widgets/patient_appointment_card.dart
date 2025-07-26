import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment_firebase_model.dart';

class PatientAppointmentCard extends StatelessWidget {
  final AppointmentFirebaseModel appointment;

  const PatientAppointmentCard({
    super.key,
    required this.appointment,
  });

  // Utility to get status and its color based on appointment status
  Map<String, dynamic> getAppointmentStatus() {
    switch (appointment.status.toLowerCase()) {
      case 'confirmed':
        return {"status": "CONFIRMED", "color": Colors.green};
      case 'pending':
        return {"status": "PENDING", "color": Colors.orange};
      case 'completed':
        return {"status": "COMPLETED", "color": Colors.blue};
      case 'cancelled':
        return {"status": "CANCELLED", "color": Colors.red};
      default:
        return {"status": "PENDING", "color": Colors.grey};
    }
  }

  // Parse appointment date and time
  DateTime? getAppointmentDateTime() {
    try {
      final dateParts = appointment.date.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        
        // Map slot to time
        int hour = 10; // Default hour
        switch (appointment.slot.toLowerCase()) {
          case 'slot 1':
            hour = 9;
            break;
          case 'slot 2':
            hour = 11;
            break;
          case 'slot 3':
            hour = 14;
            break;
        }
        
        return DateTime(year, month, day, hour, 0);
      }
    } catch (e) {
      print('Error parsing appointment time: $e');
    }
    return DateTime.now();
  }

  // Get formatted time for display
  String getFormattedTime() {
    final appointmentTime = getAppointmentDateTime();
    if (appointmentTime != null) {
      return DateFormat('hh:mm a').format(appointmentTime);
    }
    return appointment.slot;
  }

  // Get last visited text
  String getLastVisitedText() {
    final now = DateTime.now();
    final difference = now.difference(appointment.createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
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
            // Patient Avatar (since Firebase model doesn't have image path)
            Container(
              width: size.width * 0.25,
              height: size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: size.width * 0.08,
                    color: Colors.blue.shade600,
                  ),
                  Text(
                    appointment.patientName.split(' ').map((n) => n[0]).take(2).join(),
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
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
                    "${getFormattedTime()} • ${statusInfo['status']}",
                    style: TextStyle(
                      color: statusInfo['color'],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Patient Name
                  Text(
                    appointment.patientName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),

                  // Doctor Name
                  Text(
                    "Dr. ${appointment.doctorName}",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
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
                          Text("ID: ${appointment.id ?? 'N/A'}", style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.025)),
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
                          Icon(Icons.access_time, size: size.width * 0.025, color: Colors.grey),
                          SizedBox(width: size.width * 0.01),
                          Text("Date: ${appointment.date}", style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.025)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_hospital_outlined, size: size.width * 0.025, color: Colors.grey),
                          SizedBox(width: size.width * 0.01),
                          Text(appointment.hospitalName, style: TextStyle(color: Colors.grey.shade600, fontSize: size.width * 0.025)),
                        ],
                      ),
                    ],
                  ),

                  // Show reason if available
                  if (appointment.reason.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      "Reason: ${appointment.reason}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: size.width * 0.03,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // More options
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                switch (value) {
                  case 'view_details':
                    _showAppointmentDetails(context);
                    break;
                  case 'edit':
                    // Handle edit action
                    _handleEdit(context);
                    break;
                  case 'cancel':
                    // Handle cancel action
                    _handleCancel(context);
                    break;
                  case 'reschedule':
                    // Handle reschedule action
                    _handleReschedule(context);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'view_details',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 16),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                if (appointment.status.toLowerCase() == 'pending') ...[
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'reschedule',
                    child: Row(
                      children: [
                        Icon(Icons.schedule, size: 16),
                        SizedBox(width: 8),
                        Text('Reschedule'),
                      ],
                    ),
                  ),
                ],
                if (appointment.status.toLowerCase() != 'cancelled' && 
                   appointment.status.toLowerCase() != 'completed') ...[
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(Icons.cancel, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Cancel', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context) {
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Details
                _buildDetailRow('Patient Name', appointment.patientName),
                _buildDetailRow('Age', '${appointment.age} years'),
                _buildDetailRow('Gender', appointment.gender),
                _buildDetailRow('Doctor', 'Dr. ${appointment.doctorName}'),
                _buildDetailRow('Hospital', appointment.hospitalName),
                _buildDetailRow('Date', appointment.date),
                _buildDetailRow('Time Slot', appointment.slot),
                _buildDetailRow('Contact', appointment.contact),
                _buildDetailRow('Status', appointment.status.toUpperCase()),
                if (appointment.reason.isNotEmpty)
                  _buildDetailRow('Reason', appointment.reason, isLast: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
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
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: const Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _handleReschedule(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reschedule functionality will be implemented'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}