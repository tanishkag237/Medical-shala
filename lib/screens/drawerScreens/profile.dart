import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? role; // 'doctor' or 'patient'
  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isSaving = false;

  // Shared
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  // Patient-specific
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();

  // Doctor-specific
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController timingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      print('DEBUG: Fetching data for UID: $uid');
      
      if (uid == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Check patients collection
      final patientDoc = await _firestore.collection('patients').doc(uid).get();
      print('DEBUG: Patient doc exists: ${patientDoc.exists}');
      if (patientDoc.exists) {
        print('DEBUG: Patient data: ${patientDoc.data()}');
        role = 'patients';
        userData = patientDoc.data();
      } else {
        // Check doctors collection
        final doctorDoc = await _firestore.collection('doctors').doc(uid).get();
        print('DEBUG: Doctor doc exists: ${doctorDoc.exists}');
        if (doctorDoc.exists) {
          print('DEBUG: Doctor data: ${doctorDoc.data()}');
          role = 'doctors';
          userData = doctorDoc.data();
        } else {
          // Let's also check if there are documents with different structures
          print('DEBUG: No user found in patients or doctors with UID: $uid');
          
          // Check if there are any documents in doctors collection
          final doctorsSnapshot = await _firestore.collection('doctors').limit(5).get();
          print('DEBUG: Total doctors in collection: ${doctorsSnapshot.docs.length}');
          for (var doc in doctorsSnapshot.docs) {
            print('DEBUG: Doctor doc ID: ${doc.id}, data: ${doc.data()}');
          }
        }
      }

      if (userData != null) {
        nameController.text = userData!['name']?.toString() ?? '';
        // For doctors, use email field; for patients, use contact field
        if (role == 'doctors') {
          contactController.text = userData!['email']?.toString() ?? '';
        } else {
          contactController.text = userData!['contact']?.toString() ?? '';
        }

        if (role == 'patients') {
          ageController.text = userData!['age']?.toString() ?? '';
          genderController.text = userData!['gender']?.toString() ?? '';
          bloodGroupController.text = userData!['bloodGroup']?.toString() ?? '';
          allergiesController.text = userData!['allergies']?.toString() ?? '';
        } else if (role == 'doctors') {
          specializationController.text = userData!['specialization']?.toString() ?? '';
          clinicController.text = userData!['clinic']?.toString() ?? '';
          experienceController.text = userData!['experience']?.toString() ?? '';
          timingsController.text = userData!['timings']?.toString() ?? '';
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> saveProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      final userEmail = _auth.currentUser?.email;
      
      print('DEBUG: Current user UID: $uid');
      print('DEBUG: Current user email: $userEmail');
      print('DEBUG: User role: $role');
      
      if (uid == null || role == null) {
        print('ERROR: User not authenticated or role not found - UID: $uid, Role: $role');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated or role not found')),
        );
        return;
      }

      setState(() => isSaving = true);

      final updatedData = <String, dynamic>{
        'name': nameController.text.trim(),
        'updatedAt': Timestamp.now(),
      };

      if (role == 'patients') {
        updatedData.addAll({
          'contact': contactController.text.trim(),
          'age': ageController.text.trim(),
          'gender': genderController.text.trim(),
          'bloodGroup': bloodGroupController.text.trim(),
          'allergies': allergiesController.text.trim(),
        });
      } else if (role == 'doctors') {
        updatedData.addAll({
          'email': contactController.text.trim(), // For doctors, save as email
          'specialization': specializationController.text.trim(),
          'clinic': clinicController.text.trim(),
          'experience': experienceController.text.trim(),
          'timings': timingsController.text.trim(),
        });
      }

      print('DEBUG: Attempting to update collection: $role, document: $uid');
      print('DEBUG: Data to update: $updatedData');

      // Use update() instead of set() to avoid creating new documents
      await _firestore
          .collection(role!)
          .doc(uid)
          .update(updatedData);

      print('DEBUG: Profile update successful');
      setState(() => isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      print('Error saving profile: $e');
      setState(() => isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    nameController.dispose();
    contactController.dispose();
    ageController.dispose();
    genderController.dispose();
    bloodGroupController.dispose();
    allergiesController.dispose();
    specializationController.dispose();
    clinicController.dispose();
    experienceController.dispose();
    timingsController.dispose();
    super.dispose();
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "My Profile"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('User data not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: userData!['imagePath'] != null
                            ? NetworkImage(userData!['imagePath'])
                            : null,
                        child: userData!['imagePath'] == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('Name', nameController),
                      _buildTextField('Contact', contactController),

                      if (role == 'patients') ...[
                        _buildTextField('Age', ageController),
                        _buildTextField('Gender', genderController),
                        _buildTextField('Blood Group', bloodGroupController),
                        _buildTextField('Allergies', allergiesController),
                      ],

                      if (role == 'doctors') ...[
                        _buildTextField('Specialization', specializationController),
                        _buildTextField('Clinic', clinicController),
                        _buildTextField('Experience', experienceController),
                        _buildTextField('Timings', timingsController),
                      ],

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isSaving ? null : saveProfile,
                        child: isSaving
                            ? const CircularProgressIndicator()
                            : const Text('Save'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
