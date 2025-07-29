import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:MedicalShala/theme/app_colors.dart';
import '../../models/appointment_firebase_model.dart';

class SimplePatientAppointmentCard extends StatelessWidget {
  final AppointmentFirebaseModel appointment;

  const SimplePatientAppointmentCard({
    super.key,
    required this.appointment,
  });

  // Get real-time appointment status and color based on date, time, and status
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

  Color _getStatusColor() {
    final statusInfo = getAppointmentStatus();
    return statusInfo['color'];
  }

  String _getStatusText() {
    final statusInfo = getAppointmentStatus();
    return statusInfo['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
              Text(
                appointment.date,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Doctor name
          Row(
            children: [
              Icon(
                Icons.person,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dr. ${appointment.doctorName}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Hospital
          Row(
            children: [
              Icon(
                Icons.local_hospital,
                size: 20,
                color: Colors.red.shade400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  appointment.hospitalName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Time slot
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 20,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                '${getFormattedTime()} (${appointment.slot})',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
