import 'package:cloud_firestore/cloud_firestore.dart';

// Test function to add a doctor with proper image URL
Future<void> addTestDoctor() async {
  final firestore = FirebaseFirestore.instance;
  
  try {
    await firestore.collection('doctors').add({
      'name': 'Dr. Sarah Johnson',
      'specialization': 'Cardiologist',
      'clinic': 'Heart Care Center',
      'experience': '8 years',
      'timings': '9:00 AM - 6:00 PM',
      'rating': 4.8,
      'imagePath': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=300&h=400&fit=crop', // Valid image URL
      'email': 'dr.sarah@example.com',
      'uid': 'test_doctor_1',
      'registrationDate': Timestamp.now(),
      'method': 'manual',
    });
    
    print('Test doctor added successfully!');
  } catch (e) {
    print('Error adding test doctor: $e');
  }
}

// You can call this function once to add a test doctor
// addTestDoctor();
