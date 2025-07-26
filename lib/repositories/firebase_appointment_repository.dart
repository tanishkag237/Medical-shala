import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment_firebase_model.dart';
import '../repositories/appointment_repository.dart';

/// Firebase implementation of the appointment repository
class FirebaseAppointmentRepository implements AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<List<AppointmentFirebaseModel>> getCurrentUserAppointments() async* {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      yield [];
      return;
    }

    try {
      // Check if user is a doctor first
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (doctorDoc.exists) {
        yield* getDoctorAppointments(currentUser.uid);
        return;
      }

      // If not a doctor, treat as patient
      yield* getPatientAppointments(currentUser.uid);
    } catch (e) {
      print('Error getting current user appointments: $e');
      yield [];
    }
  }

  @override
  Stream<List<AppointmentFirebaseModel>> getPatientAppointments(String patientId) {
    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppointmentFirebaseModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<AppointmentFirebaseModel>> getDoctorAppointments(String doctorId) {
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppointmentFirebaseModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Future<String?> createAppointment(AppointmentFirebaseModel appointment) async {
    try {
      final docRef = await _firestore.collection('appointments').add(appointment.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating appointment: $e');
      return null;
    }
  }

  @override
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

  @override
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
      return true;
    } catch (e) {
      print('Error deleting appointment: $e');
      return false;
    }
  }

  @override
  List<AppointmentFirebaseModel> filterAppointmentsByStatus(
    List<AppointmentFirebaseModel> appointments, 
    String status
  ) {
    if (status.toLowerCase() == 'all') {
      return appointments;
    }
    return appointments
        .where((appointment) => appointment.status.toLowerCase() == status.toLowerCase())
        .toList();
  }
}
