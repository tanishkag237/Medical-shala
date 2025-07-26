import '../models/appointment_firebase_model.dart';

/// Abstract repository interface for appointments
/// This defines what operations are available without exposing implementation details
abstract class AppointmentRepository {
  /// Get appointments for the current user based on their role
  Stream<List<AppointmentFirebaseModel>> getCurrentUserAppointments();
  
  /// Get appointments for a specific patient
  Stream<List<AppointmentFirebaseModel>> getPatientAppointments(String patientId);
  
  /// Get appointments for a specific doctor
  Stream<List<AppointmentFirebaseModel>> getDoctorAppointments(String doctorId);
  
  /// Create a new appointment
  Future<String?> createAppointment(AppointmentFirebaseModel appointment);
  
  /// Update appointment status
  Future<bool> updateAppointmentStatus(String appointmentId, String status);
  
  /// Delete an appointment
  Future<bool> deleteAppointment(String appointmentId);
  
  /// Get filtered appointments by status
  List<AppointmentFirebaseModel> filterAppointmentsByStatus(
    List<AppointmentFirebaseModel> appointments, 
    String status
  );
}
