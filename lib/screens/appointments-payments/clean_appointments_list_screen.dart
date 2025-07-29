import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../controllers/appointment_controller.dart';
import '../../core/service_locator.dart';
import '../../models/appointment_firebase_model.dart';
import '../../models/user_model.dart';
import '../../widgets/dashboard/appointment-card/patient_appointment_card_new.dart';
import '../../widgets/dashboard/simple_patient_appointment_card.dart';
import '../../widgets/overview-widgets/custom_app_bar.dart';

/// Clean appointments list screen with proper separation of concerns
class CleanAppointmentsListScreen extends StatefulWidget {
  const CleanAppointmentsListScreen({super.key});

  @override
  State<CleanAppointmentsListScreen> createState() => _CleanAppointmentsListScreenState();
}

class _CleanAppointmentsListScreenState extends State<CleanAppointmentsListScreen> {
  late final AppointmentController _controller;
  List<StreamSubscription> _subscriptions = [];

  // UI State (separated from business logic)
  List<AppointmentFirebaseModel> _appointments = [];
  UserModel? _currentUser;
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _controller = ServiceLocator().get<AppointmentController>();
    _setupSubscriptions();
    _controller.initialize();
  }

  /// Setup reactive subscriptions to controller streams
  void _setupSubscriptions() {
    _subscriptions.addAll([
      // Listen to appointments changes
      _controller.appointmentsStream.listen((appointments) {
        if (mounted) {
          setState(() {
            _appointments = appointments;
          });
        }
      }),
      
      // Listen to user changes
      _controller.userStream.listen((user) {
        if (mounted) {
          setState(() {
            _currentUser = user;
          });
        }
      }),
      
      // Listen to loading state changes
      _controller.loadingStream.listen((isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = isLoading;
          });
        }
      }),
    ]);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  /// Get filtered appointments based on current filter
  List<AppointmentFirebaseModel> get _filteredAppointments {
    if (_selectedFilter == 'all') {
      return _appointments;
    }
    return _appointments
        .where((apt) => apt.status.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  /// Handle filter selection
  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _controller.setFilter(filter);
  }

  /// Handle refresh
  Future<void> _onRefresh() async {
    await _controller.refresh();
  }

  /// Handle navigation to schedule appointment
  Future<void> _onScheduleAppointment() async {
    await Navigator.pushNamed(context, '/schedule_appointment');
    // Controller will automatically update via streams
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: "Appointments"),
      body: Column(
        children: [
          // Filter tabs
          _buildFilterTabs(size),
          
          // Appointments list
          Expanded(
            child: _buildAppointmentsList(size),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Build filter tabs section
  Widget _buildFilterTabs(Size size) {
    return Container(
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
    );
  }

  /// Build individual filter chip
  Widget _buildFilterChip(String value, String label, Size size) {
    final isSelected = _selectedFilter == value;
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
        onSelected: (selected) => _onFilterSelected(value),
        backgroundColor: Colors.grey.shade200,
        selectedColor: Colors.blue,
        checkmarkColor: Colors.white,
      ),
    );
  }

  /// Build appointments list section
  Widget _buildAppointmentsList(Size size) {
    if (_isLoading && _appointments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredAppointments.isEmpty) {
      return _buildEmptyState(size);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = _filteredAppointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  /// Build appropriate appointment card based on user type
  Widget _buildAppointmentCard(AppointmentFirebaseModel appointment) {
    if (_currentUser?.isPatient == true) {
      return SimplePatientAppointmentCard(appointment: appointment);
    } else {
      return PatientAppointmentCard(appointment: appointment);
    }
  }

  /// Build empty state
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
              _selectedFilter == 'all' 
                  ? 'No appointments scheduled'
                  : 'No ${_selectedFilter} appointments',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              _getEmptyStateSubtitle(),
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.035,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (_shouldShowScheduleButton()) ...[
              SizedBox(height: size.height * 0.03),
              ElevatedButton.icon(
                onPressed: _onScheduleAppointment,
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

  /// Get empty state subtitle based on context
  String _getEmptyStateSubtitle() {
    if (_selectedFilter != 'all') {
      return 'Try selecting a different filter';
    }
    
    return _currentUser?.isPatient == true
        ? 'Schedule an appointment to get started'
        : 'No patient appointments assigned yet';
  }

  /// Check if schedule button should be shown
  bool _shouldShowScheduleButton() {
    return _selectedFilter == 'all' && _currentUser?.isPatient == true;
  }

  /// Build floating action button for patients
  Widget? _buildFloatingActionButton() {
    if (_currentUser?.isPatient != true) {
      return null;
    }

    return FloatingActionButton(
      onPressed: _onScheduleAppointment,
      child: const Icon(Icons.add),
    );
  }
}
