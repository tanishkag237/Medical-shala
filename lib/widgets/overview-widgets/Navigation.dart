import 'package:flutter/material.dart';

import '../../screens/home/ask_ai.dart';
import '../../screens/home/dashboard_screen.dart';
import '../../screens/home/inbox/inbox.dart';
import 'app_drawer.dart';

// import '../theme/app_colors.dart';
// import '../widgets/app_drawer.dart';
// import '../widgets/custom_scaffold.dart';


class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      _navigatorKeys[index].currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
      ),
    );
  }

 @override
Widget build(BuildContext context) {
  // Define titles for each screen
  // final List<String> titles = [
  //   'Appointments',
  //   'Inbox',
  //   'Ask AI',
  // ];

  return Scaffold(
    drawer: const AppDrawer(), // Drawer widget
    backgroundColor: Colors.white,
   
    body: SafeArea(
      child: Stack(
        children: [
          _buildOffstageNavigator(0, const AppointmentScreen()),
          _buildOffstageNavigator(1, const Inbox()),
          _buildOffstageNavigator(2,  AskAIScreen()),
        ],
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 0 ? 'assets/icons/schedule_selected.png' : 'assets/icons/schedule.png',
            height: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 1 ? 'assets/icons/mail_selected.png' : 'assets/icons/mail.png',
            height: 24,
          ),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            _selectedIndex == 2 ? 'assets/icons/ai_selected.png' : 'assets/icons/ai.png',
            height: 24,
          ),
          label: 'Ask AI',
        ),
      ],
    ),
  );
}
}