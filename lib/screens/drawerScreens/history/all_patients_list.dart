// screens/drawerScreens/history/patient_history.dart
import 'package:flutter/material.dart';

import '../../../widgets/patient_list_card.dart';
import '../../../data/dummy_patients.dart';

class AllPatientHistoryList extends StatefulWidget {
  const AllPatientHistoryList({super.key});

  @override
  State<AllPatientHistoryList> createState() => _AllPatientHistoryListState();
}

class _AllPatientHistoryListState extends State<AllPatientHistoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
        itemCount: dummyPatients.length,
        itemBuilder: (context, index) {
          final patient = dummyPatients[index];
          return PatientCard(patient: patient);
        },
      ),
    );
  }
}
