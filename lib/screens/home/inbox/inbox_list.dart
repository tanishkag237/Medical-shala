import 'package:flutter/material.dart';
import 'dart:async';
import '../../../models/patient_model.dart';
import '../../../services/inbox_service.dart';
import '../../../widgets/overview-widgets/app_drawer.dart';
import 'SinglePatientChat.dart';

class InboxList extends StatefulWidget {
  const InboxList({super.key});

  @override
  State<InboxList> createState() => _InboxListState();
}

class _InboxListState extends State<InboxList> {
  final InboxService _inboxService = InboxService();
  List<PatientModel> patients = [];
  bool isLoading = true;
  bool isDoctor = false;
  StreamSubscription? _patientsSubscription;

  @override
  void initState() {
    super.initState();
    _checkUserRoleAndLoadPatients();
  }

  @override
  void dispose() {
    _patientsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkUserRoleAndLoadPatients() async {
    try {
      isDoctor = await _inboxService.isCurrentUserDoctor();
      _loadPatients();
    } catch (e) {
      print('Error checking user role: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadPatients() {
    try {
      Stream<List<PatientModel>> patientsStream;
      
      if (isDoctor) {
        // If user is a doctor, get only their patients for inbox
        patientsStream = _inboxService.getInboxPatientsForCurrentDoctor();
      } else {
        // If user is a patient or admin, get all patients
        patientsStream = _inboxService.getAllPatientsForInbox();
      }

      _patientsSubscription = patientsStream.listen(
        (loadedPatients) {
          if (mounted) {
            setState(() {
              patients = loadedPatients;
              isLoading = false;
            });
          }
        },
        onError: (error) {
          print('Error loading patients: $error');
          if (mounted) {
            setState(() {
              isLoading = false;
              patients = [];
            });
          }
        },
      );
    } catch (e) {
      print('Error setting up patients stream: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: const AppDrawer(),
      body: Column(
        children: [
          // Header with patient count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isDoctor ? 'My Patients' : 'All Patients',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (!isLoading) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${patients.length} ${patients.length == 1 ? 'patient' : 'patients'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(
            thickness: 1,
            color: Colors.grey,
            height: 0,
          ),
          
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : patients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isDoctor 
                                  ? 'No patient conversations yet.\nPatients will appear here after appointments.'
                                  : 'No patients available for chat.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await _checkUserRoleAndLoadPatients();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(0, 6, 4, 6),
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final PatientModel patient = patients[index];
                            final lastMessage = patient.diagnosisDetails.isNotEmpty 
                                ? patient.diagnosisDetails.first.diagnosis 
                                : 'Tap to start conversation';
                            
                            return Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  elevation: 0,
                                  margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: Stack(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: patient.imagePath.isNotEmpty && patient.imagePath != 'assets/people/p1.jpg'
                                              ? NetworkImage(patient.imagePath) as ImageProvider
                                              : const AssetImage('assets/people/p1.jpg'),
                                          radius: 28,
                                          onBackgroundImageError: (exception, stackTrace) {
                                            print('Error loading patient image: $exception');
                                          },
                                        ),
                                        // Online indicator
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.white, width: 2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      patient.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(
                                          lastMessage,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          patient.lastVisited,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          color: Colors.grey[400],
                                          size: 20,
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => Singlepatientchat(
                                            name: patient.name,
                                            patient: patient,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[300],
                                  height: 1,
                                  indent: 80,
                                  endIndent: 16,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}