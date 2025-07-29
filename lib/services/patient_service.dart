import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/patient_model.dart';
import '../models/diagnosis_entry.dart';

class PatientService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all patients who have appointments with the current doctor
  Stream<List<PatientModel>> getPatientsForCurrentDoctor() async* {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      yield [];
      return;
    }

    try {
      // Check if current user is a doctor
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (!doctorDoc.exists) {
        print('Current user is not a doctor');
        yield [];
        return;
      }

      // Get all appointments where this doctor is assigned
      yield* _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: currentUser.uid)
          .snapshots()
          .asyncMap((appointmentSnapshot) async {
        
        Set<String> uniquePatientIds = {};
        List<PatientModel> patients = [];

        // Collect unique patient IDs from appointments
        for (var appointmentDoc in appointmentSnapshot.docs) {
          final appointmentData = appointmentDoc.data();
          final patientId = appointmentData['patientId'] as String?;
          if (patientId != null && patientId.isNotEmpty) {
            uniquePatientIds.add(patientId);
          }
        }

        // Fetch patient details for each unique patient ID
        for (String patientId in uniquePatientIds) {
          try {
            final patientDoc = await _firestore.collection('patients').doc(patientId).get();
            if (patientDoc.exists) {
              final patientData = patientDoc.data()!;
              
              // Get diagnosis history for this patient from appointments
              final patientAppointments = appointmentSnapshot.docs
                  .where((doc) => doc.data()['patientId'] == patientId)
                  .toList();
              
              List<DiagnosisEntry> diagnosisHistory = [];
              String lastVisited = 'No visits';
              DateTime? lastAppointmentDate;

              for (var appointmentDoc in patientAppointments) {
                final appointmentData = appointmentDoc.data();
                final createdAt = appointmentData['createdAt'] as Timestamp?;
                final reason = appointmentData['reason'] as String? ?? 'General consultation';
                
                if (createdAt != null) {
                  diagnosisHistory.add(
                    DiagnosisEntry(
                      diagnosis: reason,
                      date: createdAt.toDate(),
                    ),
                  );
                  
                  // Track the most recent appointment
                  if (lastAppointmentDate == null || createdAt.toDate().isAfter(lastAppointmentDate)) {
                    lastAppointmentDate = createdAt.toDate();
                    final now = DateTime.now();
                    final difference = now.difference(createdAt.toDate());
                    
                    if (difference.inDays == 0) {
                      lastVisited = 'Today';
                    } else if (difference.inDays == 1) {
                      lastVisited = 'Yesterday';
                    } else if (difference.inDays < 7) {
                      lastVisited = '${difference.inDays} days ago';
                    } else if (difference.inDays < 30) {
                      lastVisited = '${(difference.inDays / 7).floor()} weeks ago';
                    } else {
                      lastVisited = '${(difference.inDays / 30).floor()} months ago';
                    }
                  }
                }
              }

              // Sort diagnosis history by date (most recent first)
              diagnosisHistory.sort((a, b) => b.date.compareTo(a.date));

              // Create PatientModel from Firebase data
              final patient = PatientModel(
                name: patientData['name'] ?? 'Unknown Patient',
                gender: patientData['gender'] ?? 'Not specified',
                age: int.tryParse(patientData['age']?.toString() ?? '0') ?? 0,
                id: patientId.hashCode, // Use hash of ID as integer
                registrationDate: (patientData['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
                appointmentTime: lastAppointmentDate ?? DateTime.now(),
                lastVisited: lastVisited,
                contact: int.tryParse(patientData['contact']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0,
                allergies: patientData['allergies'] ?? 'None',
                bloodgroup: patientData['bloodGroup'] ?? 'Not specified',
                imagePath: patientData['imagePath']?.isNotEmpty == true 
                    ? patientData['imagePath'] 
                    : 'assets/people/p1.jpeg', // Default image
                diagnosisDetails: diagnosisHistory,
              );

              patients.add(patient);
            }
          } catch (e) {
            print('Error fetching patient $patientId: $e');
          }
        }

        // Sort patients by most recent visit
        patients.sort((a, b) => b.appointmentTime.compareTo(a.appointmentTime));
        
        return patients;
      });
    } catch (e) {
      print('Error getting patients for doctor: $e');
      yield [];
    }
  }

  /// Get all patients from the patients collection (for admin/general view)
  Stream<List<PatientModel>> getAllPatients() {
    return _firestore
        .collection('patients')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          
          return PatientModel(
            name: data['name'] ?? 'Unknown Patient',
            gender: data['gender'] ?? 'Not specified',
            age: int.tryParse(data['age']?.toString() ?? '0') ?? 0,
            id: doc.id.hashCode,
            registrationDate: (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
            appointmentTime: DateTime.now(), // Default for patients without appointments
            lastVisited: 'Not visited',
            contact: int.tryParse(data['contact']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0,
            allergies: data['allergies'] ?? 'None',
            bloodgroup: data['bloodGroup'] ?? 'Not specified',
            imagePath: data['imagePath']?.isNotEmpty == true 
                ? data['imagePath'] 
                : 'assets/people/p1.jpeg',
            diagnosisDetails: [], // Would need separate query for diagnosis history
          );
        }).toList());
  }

  /// Check if current user is a doctor
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

  /// Get patient by ID with full details
  Future<PatientModel?> getPatientById(String patientId) async {
    try {
      final patientDoc = await _firestore.collection('patients').doc(patientId).get();
      if (!patientDoc.exists) return null;

      final data = patientDoc.data()!;
      
      // Get diagnosis history from appointments
      final appointmentsSnapshot = await _firestore
          .collection('appointments')
          .where('patientId', isEqualTo: patientId)
          .orderBy('createdAt', descending: true)
          .get();

      List<DiagnosisEntry> diagnosisHistory = [];
      for (var doc in appointmentsSnapshot.docs) {
        final appointmentData = doc.data();
        final createdAt = appointmentData['createdAt'] as Timestamp?;
        final reason = appointmentData['reason'] as String? ?? 'General consultation';
        
        if (createdAt != null) {
          diagnosisHistory.add(
            DiagnosisEntry(
              diagnosis: reason,
              date: createdAt.toDate(),
            ),
          );
        }
      }

      return PatientModel(
        name: data['name'] ?? 'Unknown Patient',
        gender: data['gender'] ?? 'Not specified',
        age: int.tryParse(data['age']?.toString() ?? '0') ?? 0,
        id: patientId.hashCode,
        registrationDate: (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        appointmentTime: diagnosisHistory.isNotEmpty 
            ? diagnosisHistory.first.date 
            : DateTime.now(),
        lastVisited: diagnosisHistory.isNotEmpty 
            ? _formatLastVisited(diagnosisHistory.first.date)
            : 'No visits',
        contact: int.tryParse(data['contact']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0,
        allergies: data['allergies'] ?? 'None',
        bloodgroup: data['bloodGroup'] ?? 'Not specified',
        imagePath: data['imagePath']?.isNotEmpty == true 
            ? data['imagePath'] 
            : 'assets/people/p1.jpeg',
        diagnosisDetails: diagnosisHistory,
      );
    } catch (e) {
      print('Error fetching patient by ID: $e');
      return null;
    }
  }

  String _formatLastVisited(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}
