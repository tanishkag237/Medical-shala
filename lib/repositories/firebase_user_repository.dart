import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

/// Firebase implementation of the user repository
class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      // Check in patients collection first
      final patientDoc = await _firestore.collection('patients').doc(currentUser.uid).get();
      if (patientDoc.exists) {
        final data = patientDoc.data()!;
        data['userType'] = 'patient';
        return UserModel.fromFirestore(data, currentUser.uid);
      }

      // If not found in patients, check doctors collection
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (doctorDoc.exists) {
        final data = doctorDoc.data()!;
        data['userType'] = 'doctor';
        return UserModel.fromFirestore(data, currentUser.uid);
      }

      return null;
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }

  @override
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

  @override
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

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      // Check in patients collection first
      final patientDoc = await _firestore.collection('patients').doc(userId).get();
      if (patientDoc.exists) {
        final data = patientDoc.data()!;
        data['userType'] = 'patient';
        return UserModel.fromFirestore(data, userId);
      }

      // If not found in patients, check doctors collection
      final doctorDoc = await _firestore.collection('doctors').doc(userId).get();
      if (doctorDoc.exists) {
        final data = doctorDoc.data()!;
        data['userType'] = 'doctor';
        return UserModel.fromFirestore(data, userId);
      }

      return null;
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }
}
