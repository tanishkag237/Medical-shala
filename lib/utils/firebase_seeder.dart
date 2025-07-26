import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataSeeder {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add sample doctors to Firebase
  static Future<void> seedDoctors() async {
    final doctors = [
      {
        'name': 'Dr. John Smith',
        'specialization': 'Cardiologist',
        'clinic': 'City Hospital',
        'experience': '10 years',
        'qualification': 'MBBS, MD',
        'consultationFee': 500,
        'availableSlots': ['Slot 1', 'Slot 2', 'Slot 3'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Dr. Sarah Johnson',
        'specialization': 'Dermatologist',
        'clinic': 'Green Clinic',
        'experience': '8 years',
        'qualification': 'MBBS, MD',
        'consultationFee': 400,
        'availableSlots': ['Slot 1', 'Slot 2'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Dr. Michael Brown',
        'specialization': 'Orthopedic',
        'clinic': 'Wellness Centre',
        'experience': '12 years',
        'qualification': 'MBBS, MS',
        'consultationFee': 600,
        'availableSlots': ['Slot 2', 'Slot 3'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Dr. Emily Davis',
        'specialization': 'Pediatrician',
        'clinic': 'City Hospital',
        'experience': '6 years',
        'qualification': 'MBBS, MD',
        'consultationFee': 350,
        'availableSlots': ['Slot 1', 'Slot 3'],
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Dr. Robert Wilson',
        'specialization': 'General Physician',
        'clinic': 'Green Clinic',
        'experience': '15 years',
        'qualification': 'MBBS',
        'consultationFee': 300,
        'availableSlots': ['Slot 1', 'Slot 2', 'Slot 3'],
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    try {
      final batch = _firestore.batch();
      
      for (var doctor in doctors) {
        final docRef = _firestore.collection('doctors').doc();
        batch.set(docRef, doctor);
      }
      
      await batch.commit();
      print('Successfully added ${doctors.length} doctors to Firebase');
    } catch (e) {
      print('Error seeding doctors: $e');
    }
  }

  // Add sample appointments to Firebase (for testing)
  static Future<void> seedSampleAppointments(String currentUserId) async {
    final appointments = [
      {
        'patientName': 'John Doe',
        'patientId': currentUserId,
        'age': '30',
        'gender': 'Male',
        'reason': 'Regular checkup',
        'doctorName': 'Dr. John Smith',
        'doctorId': 'doctor_id_1',
        'hospitalName': 'City Hospital',
        'date': '28/07/2025',
        'slot': 'Slot 1',
        'contact': '+91 9876543210',
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'patientName': 'Jane Smith',
        'patientId': currentUserId,
        'age': '25',
        'gender': 'Female',
        'reason': 'Skin consultation',
        'doctorName': 'Dr. Sarah Johnson',
        'doctorId': 'doctor_id_2',
        'hospitalName': 'Green Clinic',
        'date': '29/07/2025',
        'slot': 'Slot 2',
        'contact': '+91 9876543211',
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    try {
      final batch = _firestore.batch();
      
      for (var appointment in appointments) {
        final docRef = _firestore.collection('appointments').doc();
        batch.set(docRef, appointment);
      }
      
      await batch.commit();
      print('Successfully added ${appointments.length} sample appointments to Firebase');
    } catch (e) {
      print('Error seeding appointments: $e');
    }
  }
}
