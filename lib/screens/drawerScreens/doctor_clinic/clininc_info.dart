import 'package:flutter/material.dart';
import '../../../widgets/clinic_card.dart';

class ClinicInfo extends StatefulWidget {
  const ClinicInfo({super.key});

  @override
  State<ClinicInfo> createState() => _ClinicInfoState();
}

class _ClinicInfoState extends State<ClinicInfo> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search + Filter Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                              hintText: "Search by hospital's name, location",
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
                  padding: const EdgeInsets.all(8),
                  child: Image.asset("assets/icons/filter.png"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Clinic Cards
            ClinicCard(
              clinicName: 'Sunshine Health Clinic',
              address: 'Connaught Place, Delhi',
              timings: 'Mon-Sat, 9 AM - 7 PM',
              rating: 4.9,
              reviewCount: 256,
              imagePath: 'assets/people/clinic.jpg',
            ),
            ClinicCard(
              clinicName: 'Sunshine Health Clinic',
              address: 'Connaught Place, Delhi',
              timings: 'Mon-Sat, 9 AM - 7 PM',
              rating: 4.9,
              reviewCount: 256,
              imagePath: 'assets/people/clinic.jpg',
            ),
            ClinicCard(
              clinicName: 'Sunshine Health Clinic',
              address: 'Connaught Place, Delhi',
              timings: 'Mon-Sat, 9 AM - 7 PM',
              rating: 4.9,
              reviewCount: 256,
              imagePath: 'assets/people/clinic.jpg',
            ),
            ClinicCard(
              clinicName: 'Sunshine Health Clinic',
              address: 'Connaught Place, Delhi',
              timings: 'Mon-Sat, 9 AM - 7 PM',
              rating: 4.9,
              reviewCount: 256,
              imagePath: 'assets/people/clinic.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
