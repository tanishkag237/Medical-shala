import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:MedicalShala/theme/app_colors.dart';
import '../models/appointment_firebase_model.dart';

class PatientAppointmentCard extends StatelessWidget {
  final AppointmentFirebaseModel appointment;

  const PatientAppointmentCard({super.key, required this.appointment});

  // Utility to get status and its color based on appointment status and real-time
  Map<String, dynamic> getAppointmentStatus() {
    final appointmentDateTime = getAppointmentDateTime();
    final now = DateTime.now();
    
    // If appointment is cancelled, always show cancelled
    if (appointment.status.toLowerCase() == 'cancelled') {
      return {"status": "CANCELLED", "color": Colors.red};
    }
    
    // If appointment is completed, always show completed
    if (appointment.status.toLowerCase() == 'completed') {
      return {"status": "COMPLETED", "color": Colors.blue};
    }
    
    if (appointmentDateTime != null) {
      final appointmentEndTime = appointmentDateTime.add(const Duration(hours: 1)); // Assuming 1-hour appointments
      
      // Check if appointment is in the past
      if (now.isAfter(appointmentEndTime)) {
        // If past appointment and not marked as completed, it's missed
        if (appointment.status.toLowerCase() != 'completed') {
          return {"status": "MISSED", "color": Colors.red};
        }
      }
      
      // Check if appointment is currently happening
      if (now.isAfter(appointmentDateTime) && now.isBefore(appointmentEndTime)) {
        return {"status": "IN PROGRESS", "color": Colors.purple};
      }
      
      // Future appointment - check original status
      switch (appointment.status.toLowerCase()) {
        case 'confirmed':
          return {"status": "CONFIRMED", "color": Colors.green};
        case 'pending':
          return {"status": "PENDING", "color": Colors.orange};
        default:
          return {"status": "SCHEDULED", "color": Colors.blue};
      }
    }
    
    // Fallback to original status if date parsing fails
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
        return {"status": "UNKNOWN", "color": Colors.grey};
    }
  }

  // Parse appointment date and time with improved slot mapping
  DateTime? getAppointmentDateTime() {
    try {
      final dateParts = appointment.date.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);

        // Improved slot to time mapping with more realistic appointment times
        int hour = 9; // Default hour
        int minute = 0; // Default minute
        
        switch (appointment.slot.toLowerCase()) {
          case 'slot 1':
            hour = 9;
            minute = 0; // 9:00 AM
            break;
          case 'slot 2':
            hour = 11;
            minute = 0; // 11:00 AM
            break;
          case 'slot 3':
            hour = 14;
            minute = 0; // 2:00 PM
            break;
          case 'slot 4':
            hour = 16;
            minute = 0; // 4:00 PM
            break;
          case 'slot 5':
            hour = 18;
            minute = 0; // 6:00 PM
            break;
          default:
            // Try to parse if slot contains actual time
            final timePattern = RegExp(r'(\d{1,2}):(\d{2})\s*(am|pm)?', caseSensitive: false);
            final match = timePattern.firstMatch(appointment.slot.toLowerCase());
            if (match != null) {
              hour = int.parse(match.group(1)!);
              minute = int.parse(match.group(2)!);
              final ampm = match.group(3);
              
              if (ampm != null) {
                if (ampm.toLowerCase() == 'pm' && hour != 12) {
                  hour += 12;
                } else if (ampm.toLowerCase() == 'am' && hour == 12) {
                  hour = 0;
                }
              }
            }
            break;
        }

        return DateTime(year, month, day, hour, minute);
      }
    } catch (e) {
      print('Error parsing appointment time: $e');
    }
    return null;
  }

  // Get formatted time for display with fallback
  String getFormattedTime() {
    final appointmentTime = getAppointmentDateTime();
    if (appointmentTime != null) {
      return DateFormat('hh:mm a').format(appointmentTime);
    }
    // Fallback to slot name if date parsing fails
    return appointment.slot;
  }

  // Get relative time information (e.g., "in 2 hours", "2 hours ago")
  String getRelativeTimeInfo() {
    final appointmentDateTime = getAppointmentDateTime();
    if (appointmentDateTime == null) return '';
    
    final now = DateTime.now();
    final difference = appointmentDateTime.difference(now);
    
    if (difference.isNegative) {
      // Past appointment
      final absDifference = difference.abs();
      if (absDifference.inDays > 0) {
        return '${absDifference.inDays} day${absDifference.inDays > 1 ? 's' : ''} ago';
      } else if (absDifference.inHours > 0) {
        return '${absDifference.inHours} hour${absDifference.inHours > 1 ? 's' : ''} ago';
      } else if (absDifference.inMinutes > 0) {
        return '${absDifference.inMinutes} minute${absDifference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just finished';
      }
    } else {
      // Future appointment
      if (difference.inDays > 0) {
        return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'Starting now';
      }
    }
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    size: size.width * 0.15,
                    color: AppColors.primary,
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
                  // Time + Status + Relative Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${getFormattedTime()} • ${statusInfo['status']}",
                        style: TextStyle(
                          color: statusInfo['color'],
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      if (getRelativeTimeInfo().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          getRelativeTimeInfo(),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Patient Name
                  Text(
                    appointment.patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                          Icon(
                            Icons.people_outline,
                            size: size.width * 0.025,
                            color: Colors.grey,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            "ID: ${appointment.id != null ? appointment.id!.substring(0, 5) : 'N/A'}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: size.width * 0.025,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            size: size.width * 0.025,
                            color: Colors.grey,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            "${appointment.age}, ${appointment.gender}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: size.width * 0.025,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: size.width * 0.025,
                            color: Colors.grey,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            "Date: ${appointment.date}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: size.width * 0.025,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_hospital_outlined,
                            size: size.width * 0.025,
                            color: Colors.grey,
                          ),
                          SizedBox(width: size.width * 0.01),
                          Text(
                            appointment.hospitalName,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: size.width * 0.025,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // More options
            PopupMenuButton<String>(
              color: Colors.white,
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                switch (value) {
                  case 'view_details':
                    _showAppointmentDetails(context);
                    break;
                  case 'cancel':
                    // Handle cancel action
                    _handleCancel(context);
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

                if (canCancelAppointment()) ...[
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

  //all widgets ----------------------------------------------------------
  // Check if appointment can be cancelled based on timing and status
  bool canCancelAppointment() {
    if (appointment.status.toLowerCase() == 'cancelled' ||
        appointment.status.toLowerCase() == 'completed') {
      return false;
    }
    
    final appointmentDateTime = getAppointmentDateTime();
    if (appointmentDateTime == null) return false;
    
    final now = DateTime.now();
    // Allow cancellation only if appointment is at least 1 hour in the future
    final minCancellationTime = appointmentDateTime.subtract(const Duration(hours: 1));
    
    return now.isBefore(minCancellationTime);
  }

  //all widgets ----------------------------------------------------------
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
                _buildDetailRow('Time Slot', '${appointment.slot} (${getFormattedTime()})'),
                _buildDetailRow('Scheduled Time', getRelativeTimeInfo().isNotEmpty ? getRelativeTimeInfo() : 'Unknown'),
                _buildDetailRow('Contact', appointment.contact),
                _buildDetailRow('Status', '${appointment.status.toUpperCase()} → ${getAppointmentStatus()['status']}'),
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
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCancel(BuildContext context) {
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
}
