import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';

import '../../widgets/overview-widgets/custom_app_bar.dart';
import '../../widgets/mini_overview_card.dart';
import '../../widgets/revenue_bed_allot.dart';

class BedAllocationScreen extends StatelessWidget {
  const BedAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: "Bed Allocation Details"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      

              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search  by patient’s name etc",
                  prefixIcon: const Icon(Icons.search),
                  // suffixIcon: const Icon(Icons.share_outlined),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFF3B79C1),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Overview of Patients Admitted",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            MiniOverviewCard(
                              imagePath: 'assets/overview/patient.png',
                              title: 'Total Patients',
                              count: '120',
                            ),
                            const SizedBox(width: 10),
                            MiniOverviewCard(
                              imagePath: 'assets/overview/bed.png',
                              title: 'Discharged',
                              count: '25',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            MiniOverviewCard(
                              imagePath: 'assets/overview/addfile.png',
                              title: 'New Admissions',
                              count: '30',
                            ),
                            const SizedBox(width: 10),
                            MiniOverviewCard(
                              imagePath: 'assets/overview/clock.png',
                              title: 'Remaining ',
                              count: '95',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              RevenueAnalysisChart(),

              const SizedBox(height: 12),

              const SizedBox(height: 24),

              // Bed Occupancy
             
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF8FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                     Center(
                       child: const Text(
                                       "Bed Occupancy",
                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                     ),
                     ),
                     SizedBox(height: 10),
                    _bedProgress(context, "General Beds", 0.85),
                    _bedProgress(context, "ICU Beds", 0.83),
                    _bedProgress(context, "Private Beds", 0.80),
                    _bedProgress(context, "Isolation Beds", 0.70),
                    _bedProgress(context, "Special Care Beds", 0.36),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

 Widget _bedProgress(BuildContext context, String label, double percent) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        // Progress Bar
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.transparent, // no background
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Container(
                height: 20,
                width: percent * MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 5),

        // Percentage
        Text(
          "${(percent * 100).toInt()}%",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

 }
