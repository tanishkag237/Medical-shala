// screens/drawerScreens/history/patient_history.dart
import 'package:flutter/material.dart';
import 'dart:async';

import '../../../widgets/patient_list_card.dart';
import '../../../services/patient_service.dart';
import '../../../models/patient_model.dart';

class AllPatientHistoryList extends StatefulWidget {
  const AllPatientHistoryList({super.key});

  @override
  State<AllPatientHistoryList> createState() => _AllPatientHistoryListState();
}

class _AllPatientHistoryListState extends State<AllPatientHistoryList> {
  final PatientService _patientService = PatientService();
  List<PatientModel> patients = [];
  bool isLoading = true;
  bool isDoctor = false;
  StreamSubscription? _patientsSubscription;

  @override
  void initState() {
    super.initState();
    _checkUserRoleAndLoadPatients();
  }

  @override
  void dispose() {
    _patientsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkUserRoleAndLoadPatients() async {
    try {
      isDoctor = await _patientService.isCurrentUserDoctor();
      _loadPatients();
    } catch (e) {
      print('Error checking user role: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadPatients() {
    try {
      Stream<List<PatientModel>> patientsStream;
      
      if (isDoctor) {
        // If user is a doctor, get only their patients
        patientsStream = _patientService.getPatientsForCurrentDoctor();
      } else {
        // If user is a patient or admin, get all patients
        patientsStream = _patientService.getAllPatients();
      }

      _patientsSubscription = patientsStream.listen(
        (loadedPatients) {
          if (mounted) {
            setState(() {
              patients = loadedPatients;
              isLoading = false;
            });
          }
        },
        onError: (error) {
          print('Error loading patients: $error');
          if (mounted) {
            setState(() {
              isLoading = false;
              patients = [];
            });
          }
        },
      );
    } catch (e) {
      print('Error setting up patients stream: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : patients.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isDoctor 
                            ? 'No patients found.\nPatients will appear here after appointments.'
                            : 'No patients found.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await _checkUserRoleAndLoadPatients();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      return PatientCard(patient: patient);
                    },
                  ),
                ),
    );
  }
}
