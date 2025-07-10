import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/Navigation.dart';
import '../../widgets/custom_text_field.dart';
// import '../navigation.dart';
// import 'login_screen.dart';

class DoctorLogin extends StatefulWidget {
  const DoctorLogin({super.key});

  @override
  State<DoctorLogin> createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final specializationController = TextEditingController();
  final hospitalNameController = TextEditingController();
  final fullNameController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

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
                          label: 'Specialization',
                          controller: specializationController,
                        ),
                        CustomTextField(
                          label: 'Hospital\'s / Clinic\'s Name',
                          controller: hospitalNameController,
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
                                isConfirmPasswordVisible = !isConfirmPasswordVisible;
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
                          onPressed: () {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            final confirmPassword = confirmPasswordController
                                .text
                                .trim();
                            final phone = phoneController.text.trim();
                            final specialization = specializationController.text
                                .trim();
                            final hospitalName = hospitalNameController.text
                                .trim();
                            final fullName = fullNameController.text.trim();

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match.'),
                                ),
                              );
                            } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter a valid email address.',
                                  ),
                                ),
                              );
                            } else if (phone.length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter a valid phone number.',
                                  ),
                                ),
                              );
                            } else if (email.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty ||
                                phone.isEmpty ||
                                specialization.isEmpty ||
                                hospitalName.isEmpty ||
                                fullName.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter the required fields.',
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Navigation(),
                                ),
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
                                onPressed: () {},
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
