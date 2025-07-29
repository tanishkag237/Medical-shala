import 'package:flutter/material.dart';
import 'package:MedicalShala/screens/drawerScreens/prescription.dart';
import '../../screens/drawerScreens/BedAllocationScreen.dart';
import '../../screens/drawerScreens/PaymentRevenueScreen.dart';
import '../../screens/drawerScreens/campaigns.dart';
import '../../screens/drawerScreens/doctor_clinic/tabs.dart';
import '../../screens/drawerScreens/encounter.dart';
import '../../screens/drawerScreens/history/history_tabs.dart';
import '../../screens/drawerScreens/profile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Icon(Icons.menu, color: Colors.grey),
                SizedBox(width: 10),
                Text("Categories", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          _drawerItem(context, label: "My Profile", iconPath: 'assets/icons/navigation/user.png', destination: MyProfile()),
          _drawerItem(context, label: "Encounter", iconPath: 'assets/icons/navigation/encounter.png', destination: Encounter()),
          _drawerItem(context, label: "Doctor & Clinic", iconPath: 'assets/icons/navigation/doc_clinic.png', destination: DocClinicTabs()),
          _drawerItem(context, label: "Prescription", iconPath: 'assets/icons/navigation/prescription.png', destination: PrescriptionScreen()),
          _drawerItem(context, label: "Bed Allotment", iconPath: 'assets/icons/navigation/bed_allot.png', destination: BedAllocationScreen()),
          _drawerItem(context, label: "Payment", iconPath: 'assets/icons/navigation/payment.png', destination: PaymentRevenueScreen()),
          _drawerItem(context, label: "History", iconPath: 'assets/icons/navigation/history.png', destination: HistoryAll()),
          _drawerItem(context, label: "Campaign", iconPath: 'assets/icons/navigation/campaign.png', destination: CampaignScreen()),
          _drawerItem(context, label: "Settings", iconPath: 'assets/icons/navigation/settings.png', destination: MyProfile()),
          _drawerItem(context, label: "Help & FAQs", iconPath: 'assets/icons/navigation/help.png', destination: MyProfile()),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required String iconPath,
    required String label,
    required Widget destination,
  }) {
    return ListTile(
      leading: Image.asset(iconPath, width: 24, height: 24),
      title: Text(label),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
