import '../controllers/appointment_controller.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/firebase_appointment_repository.dart';
import '../repositories/firebase_user_repository.dart';
import '../repositories/user_repository.dart';

/// Simple service locator for dependency injection
/// This helps us manage dependencies and makes testing easier
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  /// Register services (call this at app startup)
  void registerServices() {
    // Register repositories
    _services[UserRepository] = FirebaseUserRepository();
    _services[AppointmentRepository] = FirebaseAppointmentRepository();
    
    // Register controllers
    _services[AppointmentController] = AppointmentController(
      appointmentRepository: get<AppointmentRepository>(),
      userRepository: get<UserRepository>(),
    );
  }

  /// Get a service by type
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }
    return service as T;
  }

  /// Register a custom service (useful for testing)
  void register<T>(T service) {
    _services[T] = service;
  }

  /// Clear all services (useful for testing)
  void clear() {
    _services.clear();
  }
}
