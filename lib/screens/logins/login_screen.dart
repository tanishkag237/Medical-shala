import 'package:flutter/material.dart';
import 'package:MedicalShala/theme/app_colors.dart';

import '../../services/auth_service.dart';
import '../../widgets/overview-widgets/Navigation.dart';
import '../../widgets/overview-widgets/RoleSelectionDialog.dart';
import 'doc_login.dart';
import 'pateint_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
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
                        SizedBox(height: screenHeight * 0.03),
                        Center(
                          child: Image.asset(
                            "assets/logos/logo.png",
                            height: screenHeight * 0.07,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          "Sign in to your account",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.12),

                        // Email Field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Password Field
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11.0),
                            ),
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
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (_) {},
                              side: const BorderSide(color: AppColors.primary),
                            ),
                            const Text('Remember me'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(screenHeight * 0.055),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                          ),
                          onPressed: () async {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter email and password',
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              final role = await authService.loginUser(
                                email,
                                password,
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Navigation(),
                                ),
                              );

                              // Optional: show dashboard based on role
                              print('Logged in as $role');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Login failed: $e')),
                              );
                            }
                          },

                          child: const Text(
                            'Sign In',
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
                                style: TextStyle(color: Colors.black54),
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
  () async {
    try {
      final selectedRole = await showDialog<String>(
        context: context,
        builder: (_) => const RoleSelectionDialog(),
      );

      if (selectedRole == null) return; // User canceled

      final userCredential = await authService.signInWithGoogle(role: selectedRole);

      if (userCredential != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Navigation(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    }
  },
),

                            SizedBox(width: screenWidth * 0.05),
                            _socialButton(
                              "assets/logos/appleLogo.png",
                              screenWidth,
                              () {
                                // Implement Apple Sign-In here
                              },
                            ),
                          ],
                        ),

                        const Spacer(),

                        Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight * 0.02,
                            bottom: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Register as',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PateintLogin(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'User',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DoctorLogin(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Doctor',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
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

  static Widget _socialButton(
    String assetPath,
    double screenWidth,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.0),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02,
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
