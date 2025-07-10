import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const CustomAppBar(title: "My Profile"),
      body: const Center(
        child: Text('Profile Content Here'),
      ),
    );
  }
}
