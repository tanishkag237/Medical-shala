import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/firebase_seeder.dart';

class AdminTestScreen extends StatelessWidget {
  const AdminTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Test Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Data Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseDataSeeder.seedDoctors();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Doctors data seeded successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error seeding doctors: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Seed Sample Doctors'),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () async {
                try {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    await FirebaseDataSeeder.seedSampleAppointments(currentUser.uid);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sample appointments created successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please login first'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating appointments: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Create Sample Appointments'),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Navigation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/appointments_list');
              },
              child: const Text('View Appointments List'),
            ),
            
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/schedule_appointment');
              },
              child: const Text('Schedule New Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
