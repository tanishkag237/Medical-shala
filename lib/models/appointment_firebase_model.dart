import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentFirebaseModel {
  final String? id;
  final String patientName;
  final String patientId;
  final String age;
  final String gender;
  final String reason;
  final String doctorName;
  final String doctorId;
  final String hospitalName;
  final String date;
  final String slot;
  final String contact;
  final DateTime createdAt;
  final String status; // pending, confirmed, completed, cancelled

  AppointmentFirebaseModel({
    this.id,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.reason,
    required this.doctorName,
    required this.doctorId,
    required this.hospitalName,
    required this.date,
    required this.slot,
    required this.contact,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'patientName': patientName,
      'patientId': patientId,
      'age': age,
      'gender': gender,
      'reason': reason,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'hospitalName': hospitalName,
      'date': date,
      'slot': slot,
      'contact': contact,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory AppointmentFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentFirebaseModel(
      id: doc.id,
      patientName: data['patientName'] ?? '',
      patientId: data['patientId'] ?? '',
      age: data['age'] ?? '',
      gender: data['gender'] ?? '',
      reason: data['reason'] ?? '',
      doctorName: data['doctorName'] ?? '',
      doctorId: data['doctorId'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      date: data['date'] ?? '',
      slot: data['slot'] ?? '',
      contact: data['contact'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }

  factory AppointmentFirebaseModel.fromMap(Map<String, dynamic> data, String id) {
    return AppointmentFirebaseModel(
      id: id,
      patientName: data['patientName'] ?? '',
      patientId: data['patientId'] ?? '',
      age: data['age'] ?? '',
      gender: data['gender'] ?? '',
      reason: data['reason'] ?? '',
      doctorName: data['doctorName'] ?? '',
      doctorId: data['doctorId'] ?? '',
      hospitalName: data['hospitalName'] ?? '',
      date: data['date'] ?? '',
      slot: data['slot'] ?? '',
      contact: data['contact'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }
}
