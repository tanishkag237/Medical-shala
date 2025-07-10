// import 'package:flutter/material.dart';
// import '../../../data/dummy_patients.dart'; // Your dummy data file
// import '../../../models/patient_model.dart'; // Your PatientModel
// // import 'single_patient_chat.dart'; // The next screen

// class ExternalPatientChatCard extends StatelessWidget {
//   const ExternalPatientChatCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: dummyPatients.length,
//       itemBuilder: (context, index) {
//         final PatientModel patient = dummyPatients[index];
//         return Card(
//           elevation: 3,
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: AssetImage(patient.imagePath),
//               radius: 28,
//             ),
//             title: Text(
//               patient.name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             trailing: const Icon(Icons.chat_bubble_outline),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => SinglePatxientChat(name: patient.name),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
