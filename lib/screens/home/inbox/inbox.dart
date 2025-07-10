import 'package:flutter/material.dart';
import 'package:medshala/theme/app_colors.dart';
import 'package:medshala/widgets/app_drawer.dart';

import 'inbox_list.dart';



class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Move here (outside Scaffold)
      child: Scaffold(
        drawer: AppDrawer(),
        appBar:  AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black), // Ensure the menu icon is visible
            title: Text("Inbox",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu), // Menu icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open the drawer
                  },
                );
              },
            ),
            
          ),
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
                    Tab(text: "Internal Patients"),
                    Tab(text: "External Patients"),
                   
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
                    InboxList(),
                    
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
