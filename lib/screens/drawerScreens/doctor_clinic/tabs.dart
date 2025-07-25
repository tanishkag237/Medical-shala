import 'package:flutter/material.dart';

import '../../../widgets/user_avatar.dart';
import 'clininc_info.dart';
import 'doctor_info.dart';

class DocClinicTabs extends StatefulWidget {
  const DocClinicTabs({super.key});

  @override
  State<DocClinicTabs> createState() => _DocClinicTabsState();
}

class _DocClinicTabsState extends State<DocClinicTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      initialIndex: 0, // First tab (0-indexed) - this is default
      child: Scaffold(
        appBar: AppBar(
           backgroundColor: Colors.white,
            centerTitle: true,
        title: const Text(
          'Doctors & Clinic',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
         actions: [
           UserAvatar(
             radius: 18,
             margin: EdgeInsets.only(right: 10),
           ),
         ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Doctors"),
              Tab(text: "Clinics"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
           
            Center(child: DoctorInfo()),
            Center(child: ClinicInfo()),
          ],
        ),
      ),
    );
  }
}