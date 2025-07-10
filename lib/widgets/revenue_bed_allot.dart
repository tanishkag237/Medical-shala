import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueAnalysisChart extends StatefulWidget {
  const RevenueAnalysisChart({Key? key}) : super(key: key);

  @override
  State<RevenueAnalysisChart> createState() => _RevenueAnalysisChartState();
}

class _RevenueAnalysisChartState extends State<RevenueAnalysisChart> {
  String selectedPeriod = 'Weekly';

  final List<FlSpot> icuData = [
    const FlSpot(0, 3.8),
    const FlSpot(1, 6.0),
    const FlSpot(2, 7.0),
    const FlSpot(3, 5.0),
    const FlSpot(4, 8.0),
    const FlSpot(5, 5.0),
  ];

  final List<FlSpot> generalData = [
    const FlSpot(0, 10.0),
    const FlSpot(1, 12.0),
    const FlSpot(2, 11.0),
    const FlSpot(3, 10.0),
    const FlSpot(4, 10.0),
    const FlSpot(5, 12.0),
  ];

  final List<FlSpot> privateData = [
    const FlSpot(0, 4.5),
    const FlSpot(1, 6.5),
    const FlSpot(2, 5.8),
    const FlSpot(3, 4.0),
    const FlSpot(4, 8.0),
    const FlSpot(5, 3.0),
  ];

  final List<FlSpot> maternityData = [
    const FlSpot(0, 2.8),
    const FlSpot(1, 2.0),
    const FlSpot(2, 0.8),
    const FlSpot(3, 2.0),
    const FlSpot(4, 2.0),
    const FlSpot(5, 0.8),
  ];

  String getWeekday(int x) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[x % weekdays.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Revenue Analysis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: selectedPeriod,
                  underline: const SizedBox(),
                  items: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPeriod = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Wrap(
            spacing: 15,
            children: [
              _buildLegendItem('ICU', const Color(0xFF8B5CF6)),
              _buildLegendItem('General', const Color(0xFFEC4899)),
              _buildLegendItem('Private', const Color(0xFF10B981)),
              _buildLegendItem('Maternity', const Color(0xFF3B82F6)),
            ],
          ),
          const SizedBox(height: 30),

          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: false,
                  touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                    if (!event.isInterestedForInteractions || response == null) return;
                    final spot = response.lineBarSpots?.first;
                    if (spot != null) {
                      String department = '';
                      switch (spot.barIndex) {
                        case 0:
                          department = 'ICU';
                          break;
                        case 1:
                          department = 'General';
                          break;
                        case 2:
                          department = 'Private';
                          break;
                        case 3:
                          department = 'Maternity';
                          break;
                      }

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('$department Revenue'),
                          content: Text(
                            'Day: ${getWeekday(spot.x.toInt())}\nValue: ₹${spot.y.toStringAsFixed(1)} L',
                          ),
                        ),
                      );
                    }
                  },
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(
                          getWeekday(value.toInt()),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => SideTitleWidget(
                        meta: meta,
                        child: Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 12,
                lineBarsData: [
                  _lineData(icuData, const Color(0xFF8B5CF6)),
                  _lineData(generalData, const Color(0xFFEC4899)),
                  _lineData(privateData, const Color(0xFF10B981)),
                  _lineData(maternityData, const Color(0xFF3B82F6)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _lineData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
