/// Unified user model that represents both doctors and patients
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserType userType;
  final Map<String, dynamic> additionalData;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.additionalData = const {},
  });

  /// Create UserModel from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      userType: UserType.fromString(data['userType'] ?? 'patient'),
      additionalData: data,
    );
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'userType': userType.toString(),
      ...additionalData,
    };
  }

  /// Check if user is a doctor
  bool get isDoctor => userType == UserType.doctor;

  /// Check if user is a patient
  bool get isPatient => userType == UserType.patient;
}

/// Enum for user types
enum UserType {
  doctor,
  patient;

  static UserType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'doctor':
        return UserType.doctor;
      case 'patient':
        return UserType.patient;
      default:
        return UserType.patient;
    }
  }

  @override
  String toString() {
    switch (this) {
      case UserType.doctor:
        return 'doctor';
      case UserType.patient:
        return 'patient';
    }
  }
}
