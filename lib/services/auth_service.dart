import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // Google Sign-In method with role selection
  Future<UserCredential?> signInWithGoogle({required String role}) async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      await _storeGoogleUserInFirestore(
        user: userCredential.user!,
        googleUser: googleUser,
        role: role,
      );
    }

    return userCredential;
  } catch (e) {
    print('Google Sign-In Error: $e');
    rethrow;
  }
}

Future<void> _storeGoogleUserInFirestore({
  required User user,
  required GoogleSignInAccount googleUser,
  required String role,
}) async {
  final uid = user.uid;
  final mainCollection = _firestore.collection(role == 'doctor' ? 'doctors' : 'patients');
  final otherCollection = _firestore.collection(role == 'doctor' ? 'patients' : 'doctors');

  final alreadyExists = await mainCollection.doc(uid).get();
  final existsInOther = await otherCollection.doc(uid).get();

  if (existsInOther.exists) {
    throw Exception('You are already registered as a ${role == 'doctor' ? 'patient' : 'doctor'}');
  }

  if (!alreadyExists.exists) {
    final data = {
      'uid': uid,
      'name': googleUser.displayName ?? user.displayName ?? '',
      'email': googleUser.email,
      'registrationDate': Timestamp.now(),
      'method': 'google',
      'imagePath': googleUser.photoUrl ?? user.photoURL ?? '',
    };

    if (role == 'patient') {
      data.addAll({
        'age': '',
        'gender': '',
        'contact': '',
        'appointmentTime': '',
        'lastVisited': '',
        'allergies': '',
        'bloodGroup': '',
        'diagnosisDetails': [],
      });
    } else {
      data.addAll({
        'specialization': '',
        'clinic': '',
        'experience': '',
        'timings': '',
        'rating': 0,
      });
    }

    await mainCollection.doc(uid).set(data);
    print('New $role added: ${googleUser.email}');
  } else {
    print('Existing $role signed in: ${googleUser.email}');
  }
}


  // Register a patient with email/password
  Future<void> registerPatient({
    required String email,
    required String password,
    required Map<String, dynamic> patientData,
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('patients').doc(userCred.user!.uid).set(patientData);
  }

  // Register a doctor with email/password
  Future<void> registerDoctor({
    required String email,
    required String password,
    required Map<String, dynamic> doctorData,
  }) async {
    final userCred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection('doctors').doc(userCred.user!.uid).set(doctorData);
  }

  // Login user with email/password and return their role
  Future<String> loginUser(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    final patientDoc = await _firestore.collection('patients').doc(uid).get();
    if (patientDoc.exists) return 'patient';

    final doctorDoc = await _firestore.collection('doctors').doc(uid).get();
    if (doctorDoc.exists) return 'doctor';

    throw Exception('User not found in either collection');
  }

  // Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print('Successfully signed out');
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  

  // Check current user
  User? get currentUser => _auth.currentUser;

  // Login status
  bool get isLoggedIn => _auth.currentUser != null;
}
