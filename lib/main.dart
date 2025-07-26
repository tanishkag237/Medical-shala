import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'screens/logins/login_screen.dart';
import 'firebase_options.dart';
import 'screens/logins/login_screen.dart';
// import 'screens/logins/user_selection.dart';
import 'theme/app_theme.dart';
import 'core/service_locator.dart';
// import 'widgets/Navigation.dart';

void main() async {
   
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize dependency injection
  ServiceLocator().registerServices();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedShala',
      home: const LoginScreen(),
       theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}