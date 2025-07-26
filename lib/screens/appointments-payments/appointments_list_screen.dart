import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/appointment_firebase_model.dart';
import '../../services/appointment_service.dart';
import '../../widgets/patient_appointment_card.dart';
import '../../widgets/custom_app_bar.dart';

class AppointmentsListScreen extends StatefulWidget {
  const AppointmentsListScreen({super.key});

  @override
  State<AppointmentsListScreen> createState() => _AppointmentsListScreenState();
}

class _AppointmentsListScreenState extends State<AppointmentsListScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<AppointmentFirebaseModel> appointments = [];
  bool isLoading = true;
  String selectedFilter = 'all'; // all, pending, confirmed, completed, cancelled

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      isLoading = true;
    });

    try {
      _appointmentService.getUserAppointments().listen((snapshot) {
        final List<AppointmentFirebaseModel> loadedAppointments = [];
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          loadedAppointments.add(AppointmentFirebaseModel.fromMap(data, doc.id));
        }
        
        if (mounted) {
          setState(() {
            appointments = loadedAppointments;
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error loading appointments: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<AppointmentFirebaseModel> get filteredAppointments {
    if (selectedFilter == 'all') {
      return appointments;
    }
    return appointments.where((apt) => apt.status.toLowerCase() == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: "My Appointments"),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'All', size),
                  _buildFilterChip('pending', 'Pending', size),
                  _buildFilterChip('confirmed', 'Confirmed', size),
                  _buildFilterChip('completed', 'Completed', size),
                  _buildFilterChip('cancelled', 'Cancelled', size),
                ],
              ),
            ),
          ),

          // Appointments list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredAppointments.isEmpty
                    ? _buildEmptyState(size)
                    : RefreshIndicator(
                        onRefresh: _loadAppointments,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = filteredAppointments[index];
                            return PatientAppointmentCard(
                              appointment: appointment,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/schedule_appointment');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, Size size) {
    final isSelected = selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.035,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = value;
          });
        },
        backgroundColor: Colors.grey.shade200,
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState(Size size) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: size.width * 0.2,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              selectedFilter == 'all' 
                  ? 'No appointments found'
                  : 'No ${selectedFilter} appointments',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              selectedFilter == 'all'
                  ? 'Schedule your first appointment to get started'
                  : 'Try selecting a different filter',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.035,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (selectedFilter == 'all') ...[
              SizedBox(height: size.height * 0.03),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/schedule_appointment');
                },
                icon: const Icon(Icons.add),
                label: const Text('Schedule Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
