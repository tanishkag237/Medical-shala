import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../models/appointment_firebase_model.dart';
import 'appointment-card/appointment_status_helper.dart';

class AppointmentChart extends StatelessWidget {
  final List<AppointmentFirebaseModel> appointments;
  
  const AppointmentChart({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    // Count appointments by status
    int upcoming = 0;
    int ongoing = 0;
    int completed = 0;

    for (var appointment in appointments) {
      // Use real-time status calculation for consistency with appointment cards
      final statusInfo = AppointmentStatusHelper.getAppointmentStatus(appointment);
      final realTimeStatus = statusInfo['status'] as String;
      
      switch (realTimeStatus) {
        case 'PENDING':
        case 'CONFIRMED':
        case 'SCHEDULED':
          upcoming++;
          break;
        case 'IN PROGRESS':
          ongoing++;
          break;
        case 'COMPLETED':
          completed++;
          break;
        case 'CANCELLED':
        case 'MISSED':
          // Group cancelled/missed with completed to maintain 3 categories
          completed++;
          break;
        default:
          upcoming++; // Default to upcoming for unknown statuses
      }
    }

    final Map<String, double> dataMap = {
      "Upcoming": upcoming.toDouble(),
      "Ongoing": ongoing.toDouble(),
      "Completed": completed.toDouble(),
    };

    final colorList = <Color>[
      Color(0xFFA442DD),
      Color(0xFF4CAF50),
      Color(0xFFE91E63),
    ];

    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFFEFF7FF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Pie Chart
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        dataMap: dataMap,
                        chartType: ChartType.ring,
                        colorList: colorList,
                        chartRadius: 60,
                        ringStrokeWidth: 10,
                      
                        legendOptions: const LegendOptions(showLegends: false),
                        chartValuesOptions: const ChartValuesOptions(showChartValues: false),
                      ),
                     
                    ],
                  ),
                  Text(
                        "${appointments.length}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      
                ],
              ),
            ),
            const SizedBox(width: 20),

            // Legend
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildLegend("UPCOMING", upcoming, Color(0xFFA442DD)),
                  _buildLegend("ONGOING", ongoing, Color(0xFF4CAF50)),
                  _buildLegend("COMPLETED", completed, Color(0xFFE91E63)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          
          const SizedBox(width: 8),
          Row(
            children: [
              Text(
                "$count",
                style: TextStyle(fontSize: 20, color: color,fontFamily: "Poppins", fontWeight: FontWeight.w500 ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style:  TextStyle(fontSize: 18, color: Color(0xFF585858), fontFamily: "Poppins", fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
