class Appointment {
  final String name;
  final String gender;
  final int age;
  final int id;
  final DateTime appointmentTime;
  final String lastVisited;
  final String imagePath;

  Appointment({
    required this.name,
    required this.gender,
    required this.age,
    required this.id,
    required this.appointmentTime,
    required this.lastVisited,
    required this.imagePath,
  });
}
