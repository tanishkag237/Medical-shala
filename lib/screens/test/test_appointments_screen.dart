import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/appointment_service.dart';
import '../../models/appointment_firebase_model.dart';
import '../../widgets/patient_appointment_card.dart';

class TestAppointmentsScreen extends StatefulWidget {
  const TestAppointmentsScreen({super.key});

  @override
  State<TestAppointmentsScreen> createState() => _TestAppointmentsScreenState();
}

class _TestAppointmentsScreenState extends State<TestAppointmentsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentFirebaseModel> userAppointments = [];
  List<AppointmentFirebaseModel> doctorAppointments = [];
  List<AppointmentFirebaseModel> allAppointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllTypes();
  }

  Future<void> _loadAllTypes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get user/patient appointments
      _appointmentService.getUserAppointments().listen((snapshot) {
        final List<AppointmentFirebaseModel> loaded = [];
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          loaded.add(AppointmentFirebaseModel.fromMap(data, doc.id));
        }
        if (mounted) {
          setState(() {
            userAppointments = loaded;
          });
        }
      });

      // Get doctor appointments
      _appointmentService.getDoctorAppointments().listen((snapshot) {
        final List<AppointmentFirebaseModel> loaded = [];
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          loaded.add(AppointmentFirebaseModel.fromMap(data, doc.id));
        }
        if (mounted) {
          setState(() {
            doctorAppointments = loaded;
          });
        }
      });

      // Get all appointments
      _appointmentService.getAllAppointments().listen((snapshot) {
        final List<AppointmentFirebaseModel> loaded = [];
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          loaded.add(AppointmentFirebaseModel.fromMap(data, doc.id));
        }
        if (mounted) {
          setState(() {
            allAppointments = loaded;
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error loading appointments: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Appointments'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current User ID: ${FirebaseAuth.instance.currentUser?.uid ?? "Not logged in"}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Patient Appointments (${userAppointments.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (userAppointments.isEmpty)
                    const Text('No patient appointments found')
                  else
                    ...userAppointments.map((apt) => PatientAppointmentCard(appointment: apt)),

                  const SizedBox(height: 20),
                  Text(
                    'Doctor Appointments (${doctorAppointments.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (doctorAppointments.isEmpty)
                    const Text('No doctor appointments found')
                  else
                    ...doctorAppointments.map((apt) => PatientAppointmentCard(appointment: apt)),

                  const SizedBox(height: 20),
                  Text(
                    'All Appointments (${allAppointments.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (allAppointments.isEmpty)
                    const Text('No appointments found in database')
                  else
                    ...allAppointments.take(3).map((apt) => Card(
                      child: ListTile(
                        title: Text(apt.patientName),
                        subtitle: Text('Doctor: ${apt.doctorName}\nPatient ID: ${apt.patientId}\nDoctor ID: ${apt.doctorId}'),
                        trailing: Text(apt.status),
                      ),
                    )),
                ],
              ),
            ),
    );
  }
}
