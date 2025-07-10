// import 'package:flutter/material.dart';

// import '../theme/app_colors.dart';
// import '../widgets/app_drawer.dart';
// import '../widgets/custom_scaffold.dart';
// import 'home/ask_ai.dart';
// import 'home/dashboard_screen.dart';
// import 'home/inbox.dart';

// class Navigation extends StatefulWidget {
//   const Navigation({Key? key}) : super(key: key);

//   @override
//   State<Navigation> createState() => _NavigationState();
// }

// class _NavigationState extends State<Navigation> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _selectedIndex = 0;

//   // Pages with custom app bars that open the main drawer
//   late final List<Widget> _pages = [
//     CustomScaffold(title: 'Appointment', child: const AppointmentScreen(), scaffoldKey: _scaffoldKey),
//     CustomScaffold(title: 'Inbox', child: const Inbox(), scaffoldKey: _scaffoldKey),
//     CustomScaffold(title: 'Ask AI', child: const AskAI(), scaffoldKey: _scaffoldKey),
//   ];

//   void _onItemTapped(int index) => setState(() => _selectedIndex = index);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: const AppDrawer(), 
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         currentIndex: _selectedIndex,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: Colors.black,
//         onTap: _onItemTapped,
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Image.asset(
//               _selectedIndex == 0 ? 'assets/icons/schedule_selected.png' : 'assets/icons/schedule.png',
//               height: 24,
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//               _selectedIndex == 1 ? 'assets/icons/mail_selected.png' : 'assets/icons/mail.png',
//               height: 24,
//             ),
//             label: 'Inbox',
//           ),
//           BottomNavigationBarItem(
//             icon: Image.asset(
//               _selectedIndex == 2 ? 'assets/icons/ai_selected.png' : 'assets/icons/ai.png',
//               height: 24,
//             ),
//             label: 'Ask AI',
//           ),
//         ],
//       ),
//     );
//   }
// }
