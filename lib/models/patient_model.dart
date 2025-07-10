import 'diagnosis_entry.dart';

class PatientModel {
  final String name;
  final String gender;
  final int age;
  final int id; // Optional for appointment ID
  final DateTime registrationDate; // Registration or appointment date
  final DateTime appointmentTime; // For upcoming appointments
  final String lastVisited; // For dashboard use
  final int contact;
  final String allergies;
  final String bloodgroup;
  final String imagePath;
  final List<DiagnosisEntry> diagnosisDetails;


  const PatientModel({
    required this.name,
    required this.gender,
    required this.age,
    required this.id,
    required this.registrationDate,
    required this.appointmentTime,
    required this.lastVisited,
    required this.contact,
    required this.allergies,
    required this.bloodgroup,
    required this.imagePath,
    required this.diagnosisDetails,
  });
}
