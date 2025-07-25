import 'package:flutter/material.dart';
import '../../data/dummy_patients.dart'; // import dummy patients
import '../../widgets/AppointmentChart.dart';
import '../../widgets/Button_text.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/patient_appointment_card.dart';
import '../appointments-payments/schedule_appointment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const AppDrawer(),
      appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black), // Ensure the menu icon is visible
            title: Text("Appointments",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu), // Menu icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the drawer
                  },
                );
              },
            ),
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        child: Column(
          children: [
            AppointmentChart(),
            // const Card(
            //   color: Color(0xFFEEF8FF),
            //   child: Padding(
            //     padding: EdgeInsets.all(12),
            //     child: AppointmentChart()
            //   ),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonText(
                  icon: Icons.add,
                  label: "Add Appointment",
                  onPressed: () {
                    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScheduleAppointment(),
      ),
    );
                  },
                  horizontalPadding: 9,
                  verticalPadding: 9,
                ),
                ButtonText(
                  icon: Icons.videocam_outlined,
                  label: "Video Consultation",
                  onPressed: () {
                    // Add video consultation logic here
                  },
                  horizontalPadding: 10,
                  verticalPadding: 9,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🩺 Dynamic List of Appointments from dummyPatients
            ...dummyPatients
                .map((patient) => PatientAppointmentCard(appointment: patient))
                ,
          ],
        ),
      ),
    );
  }
}
