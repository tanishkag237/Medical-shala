import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/patient_service.dart';
import '../../../widgets/overview-widgets/custom_app_bar.dart';
import 'all_patients_list.dart';

class PatientHistoryScreen extends StatefulWidget {
  const PatientHistoryScreen({super.key});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> with SingleTickerProviderStateMixin {
  final PatientService _patientService = PatientService();
  late TabController _tabController;
  bool isDoctor = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkUserRole();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkUserRole() async {
    try {
      final doctorStatus = await _patientService.isCurrentUserDoctor();
      setState(() {
        isDoctor = doctorStatus;
        isLoading = false;
      });
    } catch (e) {
      print('Error checking user role: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: const CustomAppBar(title: "Patient History"),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Patient History"),
      body: Column(
        children: [
          // Tab bar for different views
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  text: isDoctor ? 'My Patients' : 'All Patients',
                  icon: Icon(
                    isDoctor ? Icons.people : Icons.people_outline,
                    size: 20,
                  ),
                ),
                const Tab(
                  text: 'Recent Visits',
                  icon: Icon(
                    Icons.history,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Patients Tab
                const AllPatientHistoryList(),
                
                // Recent Visits Tab
                _buildRecentVisitsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVisitsTab() {
    return StreamBuilder(
      stream: isDoctor 
          ? _patientService.getPatientsForCurrentDoctor()
          : _patientService.getAllPatients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading recent visits',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        final patients = snapshot.data ?? [];
        
        // Filter patients who have recent visits and sort by last visit
        final recentPatients = patients
            .where((patient) => patient.diagnosisDetails.isNotEmpty)
            .toList()
          ..sort((a, b) => b.appointmentTime.compareTo(a.appointmentTime));

        if (recentPatients.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  isDoctor 
                      ? 'No recent patient visits.\nVisits will appear here after appointments.'
                      : 'No recent visits found.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recentPatients.length,
          itemBuilder: (context, index) {
            final patient = recentPatients[index];
            final lastDiagnosis = patient.diagnosisDetails.isNotEmpty 
                ? patient.diagnosisDetails.first 
                : null;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundImage: patient.imagePath.isNotEmpty && patient.imagePath != 'assets/people/p1.jpeg'
                      ? NetworkImage(patient.imagePath) as ImageProvider
                      : const AssetImage('assets/people/p1.jpeg'),
                  radius: 30,
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading patient image: $exception');
                  },
                ),
                title: Text(
                  patient.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Last Visit: ${patient.lastVisited}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (lastDiagnosis != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Recent: ${lastDiagnosis.diagnosis}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/patient_history',
                    arguments: patient,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
