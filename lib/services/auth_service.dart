// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Register a patient
  Future<void> registerPatient({
    required String email,
    required String password,
    required Map<String, dynamic> patientData,
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('patients').doc(userCred.user!.uid).set(patientData);
  }

  // Register a doctor
  Future<void> registerDoctor({
    required String email,
    required String password,
    required Map<String, dynamic> doctorData,
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('doctors').doc(userCred.user!.uid).set(doctorData);
  }

  // Login and return role: 'patient' or 'doctor'
  Future<String> loginUser(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    final isPatient = await _firestore.collection('patients').doc(uid).get();
    if (isPatient.exists) return 'patient';

    final isDoctor = await _firestore.collection('doctors').doc(uid).get();
    if (isDoctor.exists) return 'doctor';

    throw Exception('User not found in patient or doctor collection');
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
