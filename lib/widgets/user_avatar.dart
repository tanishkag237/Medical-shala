import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAvatar extends StatelessWidget {
  final double radius;
  final EdgeInsetsGeometry? margin;

  const UserAvatar({
    Key? key,
    this.radius = 18,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: StreamBuilder<DocumentSnapshot?>(
        stream: _getUserDataStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[300],
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          }

          String? imageUrl;
          if (snapshot.hasData && snapshot.data?.exists == true) {
            final userData = snapshot.data!.data() as Map<String, dynamic>?;
            imageUrl = userData?['imagePath'];
          }

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
      ),
    );
  }

  Stream<DocumentSnapshot?> _getUserDataStream() async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield null;
      return;
    }

    final uid = user.uid;
    final firestore = FirebaseFirestore.instance;

    // First check if user exists in patients collection
    final patientDoc = await firestore.collection('patients').doc(uid).get();
    if (patientDoc.exists) {
      // Stream from patients collection
      yield* firestore.collection('patients').doc(uid).snapshots();
    } else {
      // Stream from doctors collection
      yield* firestore.collection('doctors').doc(uid).snapshots();
    }
  }
}
