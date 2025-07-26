import 'dart:async';
import '../models/appointment_firebase_model.dart';
import '../models/user_model.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/user_repository.dart';

/// Business logic controller for appointments
/// Separates UI concerns from business logic
class AppointmentController {
  final AppointmentRepository _appointmentRepository;
  final UserRepository _userRepository;

  // State management
  List<AppointmentFirebaseModel> _appointments = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  String _selectedFilter = 'all';
  StreamSubscription? _appointmentsSubscription;

  // Stream controllers for reactive UI updates
  final StreamController<List<AppointmentFirebaseModel>> _appointmentsController = 
      StreamController<List<AppointmentFirebaseModel>>.broadcast();
  final StreamController<UserModel?> _userController = 
      StreamController<UserModel?>.broadcast();
  final StreamController<bool> _loadingController = 
      StreamController<bool>.broadcast();

  AppointmentController({
    required AppointmentRepository appointmentRepository,
    required UserRepository userRepository,
  }) : _appointmentRepository = appointmentRepository,
       _userRepository = userRepository;

  // Getters for current state
  List<AppointmentFirebaseModel> get appointments => _appointments;
  List<AppointmentFirebaseModel> get filteredAppointments => 
      _appointmentRepository.filterAppointmentsByStatus(_appointments, _selectedFilter);
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;

  // Streams for reactive UI
  Stream<List<AppointmentFirebaseModel>> get appointmentsStream => _appointmentsController.stream;
  Stream<UserModel?> get userStream => _userController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  /// Initialize the controller - load user and appointments
  Future<void> initialize() async {
    await _loadCurrentUser();
    await _loadAppointments();
  }

  /// Load current user information
  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _userRepository.getCurrentUser();
      _userController.add(_currentUser);
    } catch (e) {
      print('Error loading current user: $e');
      _currentUser = null;
      _userController.add(null);
    }
  }

  /// Load appointments for current user
  Future<void> _loadAppointments() async {
    _setLoading(true);
    
    try {
      await _appointmentsSubscription?.cancel();
      
      _appointmentsSubscription = _appointmentRepository
          .getCurrentUserAppointments()
          .listen(
            (appointments) {
              _appointments = appointments;
              _appointmentsController.add(_appointments);
              _setLoading(false);
            },
            onError: (error) {
              print('Error loading appointments: $error');
              _appointments = [];
              _appointmentsController.add(_appointments);
              _setLoading(false);
            },
          );
    } catch (e) {
      print('Error setting up appointments stream: $e');
      _setLoading(false);
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await _loadCurrentUser();
    await _loadAppointments();
  }

  /// Set filter for appointments
  void setFilter(String filter) {
    _selectedFilter = filter;
    _appointmentsController.add(_appointments); // Trigger UI update
  }

  /// Create a new appointment
  Future<bool> createAppointment(AppointmentFirebaseModel appointment) async {
    try {
      final result = await _appointmentRepository.createAppointment(appointment);
      return result != null;
    } catch (e) {
      print('Error creating appointment: $e');
      return false;
    }
  }

  /// Update appointment status
  Future<bool> updateAppointmentStatus(String appointmentId, String status) async {
    try {
      return await _appointmentRepository.updateAppointmentStatus(appointmentId, status);
    } catch (e) {
      print('Error updating appointment status: $e');
      return false;
    }
  }

  /// Delete an appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      return await _appointmentRepository.deleteAppointment(appointmentId);
    } catch (e) {
      print('Error deleting appointment: $e');
      return false;
    }
  }

  /// Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    _loadingController.add(_isLoading);
  }

  /// Clean up resources
  void dispose() {
    _appointmentsSubscription?.cancel();
    _appointmentsController.close();
    _userController.close();
    _loadingController.close();
  }

  // Convenience getters for UI
  bool get isCurrentUserPatient => _currentUser?.isPatient ?? false;
  bool get isCurrentUserDoctor => _currentUser?.isDoctor ?? false;
  String get currentUserName => _currentUser?.name ?? 'Unknown';
  String get currentUserType => _currentUser?.userType.toString() ?? 'Unknown';
}
