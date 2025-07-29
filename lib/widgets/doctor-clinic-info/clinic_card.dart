

import 'package:flutter/material.dart';

class ClinicCard extends StatelessWidget {
  final String clinicName;
  final String address;
  final String timings;
  final double rating;
  final int reviewCount;
  final String imagePath;

  const ClinicCard({
    super.key,
    required this.clinicName,
    required this.address,
    required this.timings,
    required this.rating,
    required this.reviewCount,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE6F2FA), // Light blue background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade100),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 250,
              
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Clinic details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinicName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timings,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),

                

                const SizedBox(height: 8),

                // "More" link aligned right
                // Reviews and More link in one row
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      '($reviewCount reviews)',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
    ),
    GestureDetector(
      onTap: () {
        print('More tapped for $clinicName');
      },
      child: const Text(
        'More',
        style: TextStyle(
          fontSize: 14,
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ],
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
