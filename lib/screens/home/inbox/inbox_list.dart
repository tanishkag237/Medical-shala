import 'package:flutter/material.dart';
import '../../../data/dummy_patients.dart'; // Your dummy data file
import '../../../models/patient_model.dart';
import '../../../widgets/app_drawer.dart'; // Your PatientModel

class InboxList extends StatelessWidget {
  const InboxList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const AppDrawer(),
      // appBar: AppBar(
      //       backgroundColor: Colors.white,
      //       elevation: 1,
      //       centerTitle: true,
      //       iconTheme: const IconThemeData(color: Colors.black), // Ensure the menu icon is visible
      //       title: Text("Appointments",
      //         style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
      //       ),
      //       leading: Builder(
      //         builder: (context) {
      //           return IconButton(
      //             icon: const Icon(Icons.menu), // Menu icon
      //             onPressed: () {
      //               Scaffold.of(context).openDrawer(); // Open the drawer
      //             },
      //           );
      //         },
      //       ),
            
      //     ),
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
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (_) => SinglePatientChat(name: patient.name),
                        //     ),
                        //   );
                        // },
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