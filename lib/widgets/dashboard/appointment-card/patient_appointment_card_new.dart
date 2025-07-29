import 'package:flutter/material.dart';
import '../../../../models/appointment_firebase_model.dart';
import 'index.dart';

class PatientAppointmentCard extends StatelessWidget {
  final AppointmentFirebaseModel appointment;

  const PatientAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            // Patient Avatar
            AppointmentCardComponents.buildPatientAvatar(size.width),

            SizedBox(width: size.width * 0.05),

            // Main Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status and Time Header
                  AppointmentCardComponents.buildStatusTimeHeader(appointment),
                  const SizedBox(height: 4),

                  // Patient and Doctor Info
                  AppointmentCardComponents.buildPatientDoctorInfo(appointment),
                  const SizedBox(height: 10),

                  // Appointment Details
                  AppointmentCardComponents.buildDetailsRow(appointment, size.width),
                ],
              ),
            ),

            // Options Menu
            AppointmentCardComponents.buildOptionsMenu(
              context,
              appointment,
              () => _showAppointmentDetails(context),
              () => _handleCancel(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context) {
    AppointmentDetailsModal.show(context, appointment);
  }

  void _handleCancel(BuildContext context) {
    AppointmentActions.handleCancel(context, appointment);
  }
}
