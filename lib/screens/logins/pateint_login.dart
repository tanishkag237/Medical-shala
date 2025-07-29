import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/overview-widgets/Navigation.dart';
import '../../widgets/overview-widgets/custom_text_field.dart';
import 'login_screen.dart';

class PateintLogin extends StatefulWidget {
  const PateintLogin({super.key});

  @override
  State<PateintLogin> createState() => _PateintLoginState();
}

class _PateintLoginState extends State<PateintLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        Center(
                          child: Image.asset(
                            "assets/logos/logo.png",
                            height: screenHeight * 0.06,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          "Join Our Healthcare Network",
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Register to Continue",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),

                        CustomTextField(
                          label: 'Full Name',
                          controller: fullNameController,
                        ),
                        CustomTextField(
                          label: 'Email',
                          controller: emailController,
                        ),
                        CustomTextField(
                          label: 'Phone Number',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                        CustomTextField(
                          label: 'Password',
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),

                        CustomTextField(
                          label: 'Confirm Password',
                          controller: confirmPasswordController,
                          obscureText: !isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),

                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (_) {},
                              side: const BorderSide(color: AppColors.primary),
                            ),
                            const Text(
                              'Terms and Conditions',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.08),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(screenHeight * 0.055),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                          ),
                          onPressed: () async {
                          final name = fullNameController.text.trim();
                          final email = emailController.text.trim();
  final password = passwordController.text.trim();
  
  final contact = phoneController.text.trim();

  if (name.isEmpty || email.isEmpty || password.isEmpty ||  contact.isEmpty ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  try {
    // Step 1: Register user with email & password
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final uid = userCredential.user!.uid;

    // Step 2: Store user profile in Firestore (patients collection)
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(uid)
        .set({
          'name': name,
          'email': email,
          'age': '',
          'gender': '',
          'contact': contact,
          'registrationDate': Timestamp.now(),
          'uid': uid,
          'imagePath': '', // leave blank if you don't have it yet
          'appointmentTime': '',
          'lastVisited': '',
          'allergies': '',
          'bloodGroup': '',
          'diagnosisDetails': [],
        });

    // Step 3: Navigate or show success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration successful')),
    );

    // Example navigation (replace with your Dashboard or Navigation widget)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Navigation()),
    );
  } catch (e) {
    print('Registration error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registration failed: ${e.toString()}')),
    );
  }
},


                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Social Sign In
                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.black54)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Or Sign up with",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.black54)),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _socialButton(
                              "assets/logos/googleLogo.png",
                              screenWidth,
                            ),
                            SizedBox(width: screenWidth * 0.05),
                            _socialButton(
                              "assets/logos/appleLogo.png",
                              screenWidth,
                            ),
                          ],
                        ),

                        const Spacer(),

                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.03,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an Account?",
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget _socialButton(String assetPath, double screenWidth) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(11.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.015,
          horizontal: screenWidth * 0.1,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(11.0),
        ),
        child: Image.asset(assetPath, height: screenWidth * 0.08),
      ),
    );
  }
}
