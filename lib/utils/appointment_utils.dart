import '../models/patient_model.dart';

Map<String, int> getAppointmentStats(List<PatientModel> patients) {
  final now = DateTime.now();
  int upcoming = 0, ongoing = 0, missed = 0;

  for (var p in patients) {
    final diff = p.appointmentTime.difference(now);
    if (diff.inMinutes.abs() <= 15) {
      ongoing++;
    } else if (p.appointmentTime.isAfter(now)) {
      upcoming++;
    } else {
      missed++;
    }
  }

  return {
    'UPCOMING': upcoming,
    'ONGOING': ongoing,
    'MISSED': missed,
  };
}
