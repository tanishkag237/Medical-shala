import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimpleUserAvatar extends StatelessWidget {
  final double radius;

  const SimpleUserAvatar({
    Key? key,
    this.radius = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[300],
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final imageUrl = snapshot.data;
        return CircleAvatar(
          radius: radius,
          backgroundImage: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : null,
          child: imageUrl == null || imageUrl.isEmpty
              ? Icon(Icons.person, size: radius * 1.2)
              : null,
        );
      },
    );
  }

  Future<String?> _getUserImageUrl() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final uid = user.uid;
      final firestore = FirebaseFirestore.instance;

      // Check patients collection first
      final patientDoc = await firestore.collection('patients').doc(uid).get();
      if (patientDoc.exists) {
        final data = patientDoc.data();
        return data?['imagePath'] as String?;
      }

      // Check doctors collection
      final doctorDoc = await firestore.collection('doctors').doc(uid).get();
      if (doctorDoc.exists) {
        final data = doctorDoc.data();
        return data?['imagePath'] as String?;
      }

      return null;
    } catch (e) {
      print('Error fetching user image: $e');
      return null;
    }
  }
}
