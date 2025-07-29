// screens/drawerScreens/history/single_patient_history.dart
import 'package:flutter/material.dart';
import '../../../models/diagnosis_entry.dart';
import '../../../models/patient_model.dart';
import 'package:intl/intl.dart';

import '../../../widgets/overview-widgets/custom_app_bar.dart';

class SinglePatientHistory extends StatelessWidget {
  final PatientModel patient;

  const SinglePatientHistory({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:  const CustomAppBar(title: "History"),
      body: Padding(
        padding: EdgeInsetsGeometry.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: patient.imagePath.isNotEmpty && patient.imagePath != 'assets/people/p1.jpg'
                        ? NetworkImage(patient.imagePath) as ImageProvider
                        : const AssetImage('assets/people/p1.jpg'),
                    radius: 40,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading patient image: $exception');
                    },
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Registered: ${DateFormat('d MMMM, yyyy').format(patient.registrationDate)}",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                ), // increased spacing
                child: Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ), // increased padding for larger size
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Basic Information",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                      const SizedBox(height: 15),
                      _infoRow(
                        icon: Icons.person,
                        label: "Gender",
                        value: patient.gender,
                      ),
                      const SizedBox(height: 15),
                      _infoRow(
                        icon: Icons.cake_outlined,
                        label: "Age",
                        value: "${patient.age}",
                      ),
                      const SizedBox(height: 15),
                      _infoRow(
                        icon: Icons.phone_outlined,
                        label: "Contact",
                        value: " ${patient.contact}",
                      ),
                      const SizedBox(height: 15),
                      _infoRow(
                        icon: Icons.warning_amber_outlined,
                        label: "Allergies",
                        value: patient.allergies,
                      ),
                      const SizedBox(height: 15),
                      _infoRow(
                        icon: Icons.bloodtype,
                        label: "Blood Group",
                        value: patient.bloodgroup,
                      ),
                    ],
                  ),
                ),
              ),

               diagnosisCard(patient.diagnosisDetails),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _infoRow({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Row(
    children: [
      Icon(icon, color: Colors.grey[700], size: 20),
      const SizedBox(width: 10),
      Text("$label:", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}


Widget diagnosisCard(List<DiagnosisEntry> diagnosisDetails) {
  if (diagnosisDetails.isEmpty) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Medical History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No medical history available',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(color: Colors.grey, width: 0.5),
    ),
    elevation: 1,
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Medical History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${diagnosisDetails.length} record${diagnosisDetails.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...diagnosisDetails.take(5).map( // Show only recent 5 entries
            (entry) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.diagnosis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getRelativeTime(entry.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(entry.date),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (diagnosisDetails.length > 5) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                'And ${diagnosisDetails.length - 5} more record${diagnosisDetails.length - 5 > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

String _getRelativeTime(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  
  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      return '${difference.inMinutes} minutes ago';
    }
    return '${difference.inHours} hours ago';
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
