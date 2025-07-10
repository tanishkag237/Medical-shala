import 'package:flutter/material.dart';

import '../../widgets/audio_upload_encounter.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/encounter_dropdowns.dart';

class Encounter extends StatefulWidget {
  const Encounter({super.key});

  @override
  State<Encounter> createState() => _EncounterState();
}

class _EncounterState extends State<Encounter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const CustomAppBar(title: "Encounter"),
      body: Padding(padding: EdgeInsetsGeometry.all(15),
      child: Column(
        children: [
          AudioPlayerWidget(),
          const SizedBox(height: 20),
          ExpandableSections()
        ],
      ),)
    );
  }
}
