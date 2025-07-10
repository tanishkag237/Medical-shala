import 'package:flutter/material.dart';
import 'package:medshala/models/doctor_model.dart';
import '../../../widgets/doctor_info_card.dart';

class DoctorInfo extends StatefulWidget {
  const DoctorInfo({super.key});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  final TextEditingController _searchController = TextEditingController();

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

              DoctorInfoCard(
                doctor: DoctorCard(
                  name: "Dr. John Doe",
                  specialization: "Cardiologist",
                  clinic: "City Hospital",
                  experience: "10 years",
                  timings: "9 AM - 5 PM",
                  rating: 4.8,
                  imagePath: "assets/people/doc1.jpg",
                ),
              ),

               DoctorInfoCard(
                doctor: DoctorCard(
                  name: "Dr. John Doe",
                  specialization: "Cardiologist",
                  clinic: "City Hospital",
                  experience: "10 years",
                  timings: "9 AM - 5 PM",
                  rating: 4.8,
                  imagePath: "assets/people/doc1.jpg",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
