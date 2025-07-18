import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Initialize Google Sign-In (6.x API)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // Google Sign-In method using stable 6.x API
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        print('Google Sign-In cancelled by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Store user data in Firestore
      if (userCredential.user != null) {
        await _storeGoogleUserInFirestore(userCredential.user!, googleUser);
      }
      
      print('Google Sign-In successful for: ${googleUser.email}');
      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  // Store Google user data in Firestore
  Future<void> _storeGoogleUserInFirestore(User firebaseUser, GoogleSignInAccount googleUser) async {
    final uid = firebaseUser.uid;
    
    // Check if user already exists
    final userDoc = await _firestore.collection('patients').doc(uid).get();
    
    if (!userDoc.exists) {
      await _firestore.collection('patients').doc(uid).set({
        'name': googleUser.displayName ?? firebaseUser.displayName ?? '',
        'email': googleUser.email,
        'uid': uid,
        'registrationDate': Timestamp.now(),
        'method': 'google',
        'imagePath': googleUser.photoUrl ?? firebaseUser.photoURL ?? '',
        'age': '',
        'gender': '',
        'contact': '',
        'appointmentTime': '',
        'lastVisited': '',
        'allergies': '',
        'bloodGroup': '',
        'diagnosisDetails': [],
      });
      print('New Google user stored in Firestore: ${googleUser.email}');
    } else {
      print('Existing Google user signed in: ${googleUser.email}');
    }
  }

  // Register a patient
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

  // Register a doctor
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

  // Login and return role
  Future<String> loginUser(String email, String password) async {
    final userCred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;

    final isPatient = await _firestore.collection('patients').doc(uid).get();
    if (isPatient.exists) return 'patient';

    final isDoctor = await _firestore.collection('doctors').doc(uid).get();
    if (isDoctor.exists) return 'doctor';

    throw Exception('User not found in patient or doctor collection');
  }

  // Sign out from both Firebase and Google
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print('Successfully signed out from Firebase and Google');
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check login status
  bool get isLoggedIn => _auth.currentUser != null;
}
