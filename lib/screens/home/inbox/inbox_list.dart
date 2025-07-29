import 'package:flutter/material.dart';
import '../../../data/dummy_patients.dart'; // Your dummy data file
import '../../../models/patient_model.dart';
import '../../../widgets/overview-widgets/app_drawer.dart'; // Your PatientModel
import 'SinglePatientChat.dart';

class InboxList extends StatelessWidget {
  const InboxList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const AppDrawer(),
      body: Column(
        children: [
          const Divider(
            thickness: 1, // Thickness of the divider
            color: Colors.grey, // Color of the divider
            
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 6, 4, 6),
              itemCount: dummyPatients.length,
              itemBuilder: (context, index) {
                final PatientModel patient = dummyPatients[index];
                return Column(
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(patient.imagePath),
                          radius: 28,
                        ),
                        title: Text(
                          patient.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        // Uncomment this for navigation functionality
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Singlepatientchat(name: patient.name),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1, // Thickness of the divider
                      color: Colors.grey, // Color of the divider
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}