import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/appointment_firebase_model.dart';

class AppointmentStatusHelper {
  static Map<String, dynamic> getAppointmentStatus(AppointmentFirebaseModel appointment) {
    final appointmentDateTime = getAppointmentDateTime(appointment);
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
  static DateTime? getAppointmentDateTime(AppointmentFirebaseModel appointment) {
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
  static String getFormattedTime(AppointmentFirebaseModel appointment) {
    final appointmentTime = getAppointmentDateTime(appointment);
    if (appointmentTime != null) {
      return DateFormat('hh:mm a').format(appointmentTime);
    }
    // Fallback to slot name if date parsing fails
    return appointment.slot;
  }

  // Get relative time information (e.g., "in 2 hours", "2 hours ago")
  static String getRelativeTimeInfo(AppointmentFirebaseModel appointment) {
    final appointmentDateTime = getAppointmentDateTime(appointment);
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
  static String getLastVisitedText(AppointmentFirebaseModel appointment) {
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

  // Check if appointment can be cancelled based on timing and status
  static bool canCancelAppointment(AppointmentFirebaseModel appointment) {
    if (appointment.status.toLowerCase() == 'cancelled' ||
        appointment.status.toLowerCase() == 'completed') {
      return false;
    }
    
    final appointmentDateTime = getAppointmentDateTime(appointment);
    if (appointmentDateTime == null) return false;
    
    final now = DateTime.now();
    // Allow cancellation only if appointment is at least 1 hour in the future
    final minCancellationTime = appointmentDateTime.subtract(const Duration(hours: 1));
    
    return now.isBefore(minCancellationTime);
  }
}
