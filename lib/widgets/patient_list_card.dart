import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/patient_model.dart';
import '../screens/drawerScreens/history/patient_history.dart';

class PatientCard extends StatelessWidget {
  final PatientModel patient;

  const PatientCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Set background color to white
      elevation: 0, // Remove elevation
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // Remove border radius
        side: BorderSide.none, // Remove border
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(patient.imagePath),
          radius: 30,
        ),
        title: Text(
          patient.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Registered: ${DateFormat('d MMMM, yyyy').format(patient.registrationDate)}",
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SinglePatientHistory(patient: patient),
            ),
          );
        },
      ),
    );
  }
}