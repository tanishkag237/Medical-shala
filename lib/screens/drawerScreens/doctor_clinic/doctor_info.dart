import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medshala/models/doctor_model.dart';
import '../../../widgets/doctor_info_card.dart';

class DoctorInfo extends StatefulWidget {
  const DoctorInfo({super.key});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     'Doctors & Clinic',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: "Search by doctor's name, speciality",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 123, 123, 123),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset("assets/icons/filter.png"),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Doctors List from Firebase
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('doctors').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No doctors found'),
                    );
                  }

                  final doctors = snapshot.data!.docs;

                  // Filter doctors based on search query
                  final filteredDoctors = doctors.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final specialization = (data['specialization'] ?? '').toString().toLowerCase();
                    
                    return _searchQuery.isEmpty ||
                           name.contains(_searchQuery) ||
                           specialization.contains(_searchQuery);
                  }).toList();

                  if (filteredDoctors.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isEmpty ? 'No doctors found' : 'No doctors match your search',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return Column(
                    children: filteredDoctors.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      
                      // Debug: Print the actual data from Firebase
                      print('DEBUG: Doctor data from Firebase: $data');
                      print('DEBUG: Image path: ${data['imagePath']}');
                      
                      // Create DoctorCard from Firebase data
                      final doctor = DoctorCard(
                        name: data['name'] ?? 'Unknown Doctor',
                        specialization: data['specialization'] ?? 'General',
                        clinic: data['clinic'] ?? 'Unknown Clinic',
                        experience: data['experience'] ?? '0 years',
                        timings: data['timings'] ?? 'Not specified',
                        rating: (data['rating'] ?? 0).toDouble(),
                        imagePath: data['imagePath'] ?? 'assets/people/doc1.jpg',
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: DoctorInfoCard(doctor: doctor),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
