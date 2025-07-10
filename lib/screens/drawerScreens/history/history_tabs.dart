import 'package:flutter/material.dart';
import 'package:medshala/theme/app_colors.dart';

import '../../../widgets/custom_app_bar.dart';
import 'all_patients_list.dart';

class HistoryAll extends StatefulWidget {
  const HistoryAll({super.key});

  @override
  State<HistoryAll> createState() => _HistoryAllState();
}

class _HistoryAllState extends State<HistoryAll> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Move here (outside Scaffold)
      child: Scaffold(
        appBar:  const CustomAppBar(title: "History"),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 123, 123, 123),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 113, 113, 113),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 123, 123, 123),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tab Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: TabBar(
                  isScrollable: false,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  tabs: const [
                    Tab(text: "Internal"),
                    Tab(text: "External"),
                    Tab(text: "Patients"),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Tab Views
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Text(
                        "All Internal Patients Content",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Center(
                      child: Text(
                        "All External Patients Content",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    AllPatientHistoryList()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
