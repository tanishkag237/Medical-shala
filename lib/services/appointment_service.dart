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
        .snapshots();
  }

  // Get all appointments (for doctors/admin)
  Stream<QuerySnapshot> getAllAppointments() {
    return _firestore
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get appointments for doctors (patients assigned to them)
  Stream<QuerySnapshot> getDoctorAppointments() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.empty();
    }

    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: currentUser.uid)
        .snapshots();
  }

  // Get appointments based on user role
  Stream<QuerySnapshot> getAppointmentsForCurrentUser() async* {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      yield* Stream.empty();
      return;
    }

    try {
      // Check if user is a doctor first
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (doctorDoc.exists) {
        // User is a doctor, get appointments where they are the assigned doctor
        print('Loading appointments for doctor: ${currentUser.uid}');
        yield* getDoctorAppointments();
        return;
      }

      // Check if user is a patient
      final patientDoc = await _firestore.collection('patients').doc(currentUser.uid).get();
      if (patientDoc.exists) {
        // User is a patient, get their appointments
        print('Loading appointments for patient: ${currentUser.uid}');
        yield* getUserAppointments();
        return;
      }

      // If user is not found in either collection, still try to get their appointments as patient
      // This handles cases where user might exist in auth but not yet in Firestore collections
      print('User not found in doctors or patients collections, defaulting to patient appointments for: ${currentUser.uid}');
      yield* getUserAppointments();
    } catch (e) {
      print('Error determining user role for appointments: $e');
      yield* Stream.empty();
    }
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
        final data = patientDoc.data()!;
        data['userType'] = 'patient';
        return data;
      }

      // If not found in patients, check doctors collection
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (doctorDoc.exists) {
        final data = doctorDoc.data()!;
        data['userType'] = 'doctor';
        return data;
      }

      return null;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Check if current user is a doctor
  Future<bool> isCurrentUserDoctor() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      return doctorDoc.exists;
    } catch (e) {
      print('Error checking if user is doctor: $e');
      return false;
    }
  }

  // Check if current user is a patient
  Future<bool> isCurrentUserPatient() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final patientDoc = await _firestore.collection('patients').doc(currentUser.uid).get();
      return patientDoc.exists;
    } catch (e) {
      print('Error checking if user is patient: $e');
      return false;
    }
  }

  // Debug method to get all appointments with user info
  Future<List<Map<String, dynamic>>> getAllAppointmentsWithDetails() async {
    try {
      final snapshot = await _firestore.collection('appointments').get();
      List<Map<String, dynamic>> appointments = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        appointments.add(data);
      }
      
      return appointments;
    } catch (e) {
      print('Error getting all appointments: $e');
      return [];
    }
  }
}
