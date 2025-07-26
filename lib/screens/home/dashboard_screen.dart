import 'package:flutter/material.dart';
import '../../models/appointment_firebase_model.dart';
import '../../services/appointment_service.dart';
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
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentFirebaseModel> appointments = [];
  bool isLoadingAppointments = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      isLoadingAppointments = true;
    });

    try {
      _appointmentService.getUserAppointments().listen((snapshot) {
        final List<AppointmentFirebaseModel> loadedAppointments = [];
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          loadedAppointments.add(AppointmentFirebaseModel.fromMap(data, doc.id));
        }
        
        if (mounted) {
          setState(() {
            appointments = loadedAppointments;
            isLoadingAppointments = false;
          });
        }
      });
    } catch (e) {
      print('Error loading appointments: $e');
      if (mounted) {
        setState(() {
          isLoadingAppointments = false;
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading appointments: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Appointments",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppointments,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
          child: Column(
            children: [
              const AppointmentChart(),

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

              // 🩺 Dynamic List of Appointments from Firebase
              if (isLoadingAppointments)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (appointments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No appointments found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Schedule your first appointment to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...appointments.map((appointment) => 
                  PatientAppointmentCard(appointment: appointment)),
            ],
          ),
        ),
      ),
    );
  }
}
