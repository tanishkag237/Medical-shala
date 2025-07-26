import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/appointment_service.dart';

class DebugAppointmentsScreen extends StatefulWidget {
  const DebugAppointmentsScreen({super.key});

  @override
  State<DebugAppointmentsScreen> createState() => _DebugAppointmentsScreenState();
}

class _DebugAppointmentsScreenState extends State<DebugAppointmentsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<Map<String, dynamic>> allAppointments = [];
  Map<String, dynamic>? currentUserDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get current user details
      final userDetails = await _appointmentService.getCurrentUserDetails();
      
      // Get all appointments
      final appointments = await _appointmentService.getAllAppointmentsWithDetails();

      if (mounted) {
        setState(() {
          currentUserDetails = userDetails;
          allAppointments = appointments;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading debug info: $e');
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
        title: const Text('Debug Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDebugInfo,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current User Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current User Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('User ID: ${FirebaseAuth.instance.currentUser?.uid ?? "Not logged in"}'),
                          Text('Email: ${FirebaseAuth.instance.currentUser?.email ?? "No email"}'),
                          if (currentUserDetails != null) ...[
                            Text('Name: ${currentUserDetails!['name'] ?? "Unknown"}'),
                            Text('User Type: ${currentUserDetails!['userType'] ?? "Unknown"}'),
                          ] else
                            const Text('User not found in Firestore collections'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // All Appointments
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'All Appointments in Database (${allAppointments.length})',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          if (allAppointments.isEmpty)
                            const Text('No appointments found in database')
                          else
                            ...allAppointments.map((apt) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Patient: ${apt['patientName']} (ID: ${apt['patientId']})'),
                                  Text('Doctor: ${apt['doctorName']} (ID: ${apt['doctorId']})'),
                                  Text('Status: ${apt['status']} | Date: ${apt['date']}'),
                                  Text('Hospital: ${apt['hospitalName']}'),
                                  if (apt['reason'] != null && apt['reason'].isNotEmpty)
                                    Text('Reason: ${apt['reason']}'),
                                ],
                              ),
                            )),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final isDoctor = await _appointmentService.isCurrentUserDoctor();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Is Doctor: $isDoctor'),
                              ),
                            );
                          },
                          child: const Text('Check if Doctor'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final isPatient = await _appointmentService.isCurrentUserPatient();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Is Patient: $isPatient'),
                              ),
                            );
                          },
                          child: const Text('Check if Patient'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
