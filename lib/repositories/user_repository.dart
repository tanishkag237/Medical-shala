import '../models/user_model.dart';

/// Abstract repository interface for user operations
abstract class UserRepository {
  /// Get current user details with role information
  Future<UserModel?> getCurrentUser();
  
  /// Check if current user is a doctor
  Future<bool> isCurrentUserDoctor();
  
  /// Check if current user is a patient
  Future<bool> isCurrentUserPatient();
  
  /// Get user by ID
  Future<UserModel?> getUserById(String userId);
}
