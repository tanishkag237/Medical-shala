import 'package:flutter/material.dart';
import '../../../services/patient_service.dart';
import '../../../services/appointment_service.dart';
import '../../../widgets/overview-widgets/custom_app_bar.dart';

class PatientDataDebugScreen extends StatefulWidget {
  const PatientDataDebugScreen({super.key});

  @override
  State<PatientDataDebugScreen> createState() => _PatientDataDebugScreenState();
}

class _PatientDataDebugScreenState extends State<PatientDataDebugScreen> {
  final PatientService _patientService = PatientService();
  final AppointmentService _appointmentService = AppointmentService();
  Map<String, dynamic> debugInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    try {
      // Check user role
      final isDoctor = await _patientService.isCurrentUserDoctor();
      final userDetails = await _appointmentService.getCurrentUserDetails();
      
      // Get all appointments with details
      final appointmentsWithDetails = await _appointmentService.getAllAppointmentsWithDetails();
      
      setState(() {
        debugInfo = {
          'isDoctor': isDoctor,
          'userDetails': userDetails,
          'appointmentsCount': appointmentsWithDetails.length,
          'appointments': appointmentsWithDetails.take(5).toList(), // Show first 5
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        debugInfo = {
          'error': e.toString(),
        };
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Debug Patient Data"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard('User Information', {
                      'Is Doctor': debugInfo['isDoctor']?.toString() ?? 'Unknown',
                      'User Type': debugInfo['userDetails']?['userType'] ?? 'Unknown',
                      'User Name': debugInfo['userDetails']?['name'] ?? 'Unknown',
                      'User Email': debugInfo['userDetails']?['email'] ?? 'Unknown',
                    }),
                    
                    const SizedBox(height: 16),
                    
                    _buildInfoCard('Appointments Information', {
                      'Total Appointments': debugInfo['appointmentsCount']?.toString() ?? '0',
                    }),
                    
                    const SizedBox(height: 16),
                    
                    if (debugInfo['appointments'] != null) ...[
                      const Text(
                        'Recent Appointments:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...((debugInfo['appointments'] as List).map((appointment) => 
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient: ${appointment['patientName'] ?? 'Unknown'}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Doctor: ${appointment['doctorName'] ?? 'Unknown'}'),
                                Text('Patient ID: ${appointment['patientId'] ?? 'Unknown'}'),
                                Text('Doctor ID: ${appointment['doctorId'] ?? 'Unknown'}'),
                                Text('Status: ${appointment['status'] ?? 'Unknown'}'),
                                Text('Date: ${appointment['date'] ?? 'Unknown'}'),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                    
                    if (debugInfo['error'] != null) ...[
                      Card(
                        color: Colors.red[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Error:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                debugInfo['error'].toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          _loadDebugInfo();
                        },
                        child: const Text('Refresh Debug Info'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(String title, Map<String, String> info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...info.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(entry.value),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
