import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/patient_model.dart';
import '../models/diagnosis_entry.dart';

class InboxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all patients from the patients collection
  Stream<List<PatientModel>> getAllPatientsForInbox() {
    return _firestore
        .collection('patients')
        .orderBy('registrationDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          
          return PatientModel(
            name: data['name'] ?? 'Unknown Patient',
            gender: data['gender'] ?? 'Not specified',
            age: int.tryParse(data['age']?.toString() ?? '0') ?? 0,
            id: doc.id.hashCode,
            registrationDate: (data['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
            appointmentTime: DateTime.now(),
            lastVisited: 'Available for chat',
            contact: int.tryParse(data['contact']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0,
            allergies: data['allergies'] ?? 'None',
            bloodgroup: data['bloodGroup'] ?? 'Not specified',
            imagePath: data['imagePath']?.isNotEmpty == true 
                ? data['imagePath'] 
                : 'assets/people/p1.jpeg',
            diagnosisDetails: [
              DiagnosisEntry(
                diagnosis: 'Ready to chat',
                date: DateTime.now(),
              ),
            ],
          );
        }).toList());
  }

  /// Get patients for inbox (patients who have had conversations/appointments with current doctor)
  Stream<List<PatientModel>> getInboxPatientsForCurrentDoctor() async* {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      yield [];
      return;
    }

    try {
      // Check if current user is a doctor
      final doctorDoc = await _firestore.collection('doctors').doc(currentUser.uid).get();
      if (!doctorDoc.exists) {
        print('Current user is not a doctor, showing all patients');
        yield* getAllPatientsForInbox();
        return;
      }

      // Get all appointments where this doctor is assigned
      yield* _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: currentUser.uid)
          .snapshots()
          .asyncMap((appointmentSnapshot) async {
        
        Map<String, DateTime> patientLastContact = {};
        Map<String, String> patientLastMessage = {};
        List<PatientModel> patients = [];

        // Collect unique patient IDs and their last contact info
        for (var appointmentDoc in appointmentSnapshot.docs) {
          final appointmentData = appointmentDoc.data();
          final patientId = appointmentData['patientId'] as String?;
          final createdAt = appointmentData['createdAt'] as Timestamp?;
          final reason = appointmentData['reason'] as String? ?? 'Appointment scheduled';
          
          if (patientId != null && patientId.isNotEmpty && createdAt != null) {
            final contactDate = createdAt.toDate();
            
            // Keep track of the most recent contact
            if (!patientLastContact.containsKey(patientId) || 
                contactDate.isAfter(patientLastContact[patientId]!)) {
              patientLastContact[patientId] = contactDate;
              patientLastMessage[patientId] = reason;
            }
          }
        }

        // Fetch patient details for each unique patient ID
        for (String patientId in patientLastContact.keys) {
          try {
            final patientDoc = await _firestore.collection('patients').doc(patientId).get();
            if (patientDoc.exists) {
              final patientData = patientDoc.data()!;
              
              final lastContactDate = patientLastContact[patientId]!;
              final lastMessage = patientLastMessage[patientId] ?? 'No recent activity';
              
              // Create PatientModel with inbox-specific data
              final patient = PatientModel(
                name: patientData['name'] ?? 'Unknown Patient',
                gender: patientData['gender'] ?? 'Not specified',
                age: int.tryParse(patientData['age']?.toString() ?? '0') ?? 0,
                id: patientId.hashCode,
                registrationDate: (patientData['registrationDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
                appointmentTime: lastContactDate,
                lastVisited: _formatLastContactTime(lastContactDate),
                contact: int.tryParse(patientData['contact']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '0') ?? 0,
                allergies: patientData['allergies'] ?? 'None',
                bloodgroup: patientData['bloodGroup'] ?? 'Not specified',
                imagePath: patientData['imagePath']?.isNotEmpty == true 
                    ? patientData['imagePath'] 
                    : 'assets/people/p1.jpeg',
                diagnosisDetails: [
                  DiagnosisEntry(
                    diagnosis: lastMessage,
                    date: lastContactDate,
                  ),
                ],
              );

              patients.add(patient);
            }
          } catch (e) {
            print('Error fetching patient $patientId for inbox: $e');
          }
        }

        // Sort patients by most recent contact (most recent first)
        patients.sort((a, b) => b.appointmentTime.compareTo(a.appointmentTime));
        
        return patients;
      });
    } catch (e) {
      print('Error getting inbox patients for doctor: $e');
      yield [];
    }
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

  String _formatLastContactTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
