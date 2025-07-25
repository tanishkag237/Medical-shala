import 'package:flutter/material.dart';
import '../models/doctor_model.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorCard doctor; // Use the Doctor model class

  const DoctorInfoCard({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEEF8FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildDoctorImage(),
            ),

            const SizedBox(width: 16),

            // Doctor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${doctor.name} (${doctor.specialization})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.clinic,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${doctor.experience} Experience',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.timings,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Ratings: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        doctor.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorImage() {
    // Check if imagePath is a URL that starts with http
    if (doctor.imagePath.startsWith('http')) {
      // Network image from Firebase
      return Image.network(
        doctor.imagePath,
        width: 116,
        height: 150,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) {
          print('Failed to load image: ${doctor.imagePath}');
          print('Error: $error');
          // Fallback to default asset if network image fails
          return Image.asset(
            'assets/people/doc1.jpg',
            width: 116,
            height: 150,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 116,
            height: 150,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } else {
      // Asset image (fallback) or invalid URL
      return Image.asset(
        doctor.imagePath.startsWith('assets/') ? doctor.imagePath : 'assets/people/doc1.jpg',
        width: 116,
        height: 150,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) {
          // If even the asset fails, show a placeholder
          return Container(
            width: 116,
            height: 150,
            color: Colors.grey[300],
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }
}