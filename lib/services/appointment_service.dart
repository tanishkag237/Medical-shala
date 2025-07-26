import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_firebase_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all doctors from Firebase
  Stream<QuerySnapshot> getDoctors() {
    return _firestore.collection('doctors').snapshots();
  }

  // Get doctor details by ID
  Future<DocumentSnapshot?> getDoctorById(String doctorId) async {
    try {
      return await _firestore.collection('doctors').doc(doctorId).get();
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  // Create a new appointment
  Future<String?> createAppointment(AppointmentFirebaseModel appointment) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Add the appointment to the appointments collection
      final docRef = await _firestore.collection('appointments').add(appointment.toMap());
      
      print('Appointment created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating appointment: $e');
      return null;
    }
  }

  // Get all appointments for the current user
  Stream<QuerySnapshot> getUserAppointments() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get all appointments (for doctors/admin)
  Stream<QuerySnapshot> getAllAppointments() {
    return _firestore
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).update({
        'status': status,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Error updating appointment status: $e');
      return false;
    }
  }

  // Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
      return true;
    } catch (e) {
      print('Error deleting appointment: $e');
      return false;
    }
  }

  // Get current user details
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      // Check in patients collection first
      final patientDoc = await _firestore.collection('patients').doc(currentUser.uid).get();
      if (patientDoc.exists) {
        return patientDoc.data();
      }

      // If not found in patients, check doctors collection
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (doctorDoc.exists) {
        return doctorDoc.data();
      }

      return null;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}
