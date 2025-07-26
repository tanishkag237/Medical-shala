import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../models/appointment_firebase_model.dart';
import '../../services/appointment_service.dart';
import '../../widgets/patient_appointment_card.dart';
import '../../widgets/simple_patient_appointment_card.dart';
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
  String userType = 'Unknown';
  String userName = 'Unknown';
  StreamSubscription? _appointmentsSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadAppointments();
    
    // Safety timeout to prevent infinite loading
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _appointmentsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userDetails = await _appointmentService.getCurrentUserDetails();
      if (userDetails != null && mounted) {
        setState(() {
          userType = userDetails['userType'] ?? 'Unknown';
          userName = userDetails['name'] ?? 'Unknown';
        });
      }
    } catch (e) {
      print('Error loading user info: $e');
    }
  }

  Future<void> _loadAppointments() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      print('Loading appointments for current user...');
      
      // Cancel existing subscription if any
      await _appointmentsSubscription?.cancel();
      
      // Create new subscription
      _appointmentsSubscription = _appointmentService.getAppointmentsForCurrentUser().listen((snapshot) {
        if (!mounted) return;
        
        final List<AppointmentFirebaseModel> loadedAppointments = [];
        print('Received ${snapshot.docs.length} appointments from Firebase');
        
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final appointment = AppointmentFirebaseModel.fromMap(data, doc.id);
          loadedAppointments.add(appointment);
          print('Appointment: ${appointment.patientName} -> Dr. ${appointment.doctorName} (${appointment.status})');
        }
        
        setState(() {
          appointments = loadedAppointments;
          isLoading = false; // Always set loading to false when we get data (even if empty)
        });
      }, onError: (error) {
        print('Error in appointments stream: $error');
        if (mounted) {
          setState(() {
            isLoading = false;
            appointments = [];
          });
        }
      });
    } catch (e) {
      print('Error loading appointments: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          appointments = [];
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
      appBar: const CustomAppBar(title: "Appointments"),
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
            child: isLoading && appointments.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filteredAppointments.isEmpty
                    ? _buildEmptyState(size)
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _loadUserInfo();
                          await _loadAppointments();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = filteredAppointments[index];
                            
                            // Use simple card for patients, detailed card for doctors
                            if (userType.toLowerCase() == 'patient') {
                              return SimplePatientAppointmentCard(
                                appointment: appointment,
                              );
                            } else {
                              return PatientAppointmentCard(
                                appointment: appointment,
                              );
                            }
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: userType.toLowerCase() == 'patient' 
          ? FloatingActionButton(
              onPressed: () async {
                // Navigate to schedule appointment and refresh when returning
                await Navigator.pushNamed(context, '/schedule_appointment');
                // Refresh appointments when user returns
                if (mounted) {
                  _loadAppointments();
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
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
                  ? 'No appointments scheduled'
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
                  ? userType.toLowerCase() == 'patient' 
                      ? 'Schedule an appointment to get started'
                      : 'No patient appointments assigned yet'
                  : 'Try selecting a different filter',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.035,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (selectedFilter == 'all' && userType.toLowerCase() == 'patient') ...[
              SizedBox(height: size.height * 0.03),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/schedule_appointment');
                  if (mounted) {
                    _loadAppointments();
                  }
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
