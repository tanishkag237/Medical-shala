import 'package:flutter/material.dart';
import 'package:medshala/theme/app_colors.dart';
import '../../models/appointment_firebase_model.dart';
import 'appointment_status_helper.dart';

class AppointmentCardComponents {
  
  // Patient Avatar Component
  static Widget buildPatientAvatar(double size) {
    return Container(
      width: size * 0.25,
      height: size * 0.25,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: size * 0.15,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // Status and Time Header Component
  static Widget buildStatusTimeHeader(AppointmentFirebaseModel appointment) {
    final statusInfo = AppointmentStatusHelper.getAppointmentStatus(appointment);
    final relativeTime = AppointmentStatusHelper.getRelativeTimeInfo(appointment);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppointmentStatusHelper.getFormattedTime(appointment)} • ${statusInfo['status']}",
          style: TextStyle(
            color: statusInfo['color'],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        if (relativeTime.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            relativeTime,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  // Patient and Doctor Info Component
  static Widget buildPatientDoctorInfo(AppointmentFirebaseModel appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // Text(
        //   "Dr. ${appointment.doctorName}",
        //   style: TextStyle(
        //     color: Colors.blue.shade700,
        //     fontWeight: FontWeight.w500,
        //     fontSize: 14,
        //   ),
        // ),
      ],
    );
  }

  // Appointment Details Row Component
  static Widget buildDetailsRow(AppointmentFirebaseModel appointment, double screenWidth) {
    return Wrap(
      spacing: screenWidth * 0.02,
      runSpacing: screenWidth * 0.01,
      children: [
        _buildDetailItem(
          Icons.people_outline,
          "ID: ${appointment.id != null ? appointment.id!.substring(0, 5) : 'N/A'}",
          screenWidth,
        ),
        _buildDetailItem(
          Icons.person_2_outlined,
          "${appointment.age}, ${appointment.gender}",
          screenWidth,
        ),
        _buildDetailItem(
          Icons.access_time,
          "Date: ${appointment.date}",
          screenWidth,
        ),
        _buildDetailItem(
          Icons.local_hospital_outlined,
          appointment.hospitalName,
          screenWidth,
        ),
      ],
    );
  }

  // Helper method for detail items
  static Widget _buildDetailItem(IconData icon, String text, double screenWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: screenWidth * 0.025,
          color: Colors.grey,
        ),
        SizedBox(width: screenWidth * 0.01),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: screenWidth * 0.025,
          ),
        ),
      ],
    );
  }

  // Options Menu Component
  static Widget buildOptionsMenu(
    BuildContext context,
    AppointmentFirebaseModel appointment,
    VoidCallback onViewDetails,
    VoidCallback onCancel,
  ) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        switch (value) {
          case 'view_details':
            onViewDetails();
            break;
          case 'cancel':
            onCancel();
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
        if (AppointmentStatusHelper.canCancelAppointment(appointment)) ...[
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
    );
  }
}
