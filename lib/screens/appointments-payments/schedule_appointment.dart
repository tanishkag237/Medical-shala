import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:MedicalShala/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/appointment_details_data.dart';
import '../../models/appointment_firebase_model.dart';
import '../../services/appointment_service.dart';
import '../../widgets/overview-widgets/Button_text.dart';
import '../../widgets/overview-widgets/custom_app_bar.dart';
import 'appointment_details.dart';

class ScheduleAppointment extends StatefulWidget {
  const ScheduleAppointment({super.key});

  @override
  State<ScheduleAppointment> createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  final _formKey = GlobalKey<FormState>();
  final AppointmentService _appointmentService = AppointmentService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? selectedDoctor;
  String? selectedDoctorId;
  String? selectedHospital;
  String? selectedDate;
  String? selectedSlot;
  String? gender;

  List<Map<String, dynamic>> doctors = [];
  bool isLoadingDoctors = true;
  bool isSubmitting = false;

  final List<String> hospitals = [
    'City Hospital',
    'Green Clinic',
    'Wellness Centre',
  ];
  final List<String> dates = ['20/06/2025', '21/06/2025', '22/06/2025'];
  final List<String> slots = ['Slot 1', 'Slot 2', 'Slot 3'];

  @override
  void initState() {
    super.initState();
    _loadDoctors();
    _loadUserDetails();
  }

  Future<void> _loadDoctors() async {
    setState(() {
      isLoadingDoctors = true;
    });

    try {
      _appointmentService.getDoctors().listen((snapshot) {
        final List<Map<String, dynamic>> loadedDoctors = [];
        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          loadedDoctors.add({
            'id': doc.id,
            'name': data['name'] ?? 'Unknown Doctor',
            'specialization': data['specialization'] ?? 'General',
            'clinic': data['clinic'] ?? 'Unknown Clinic',
          });
        }
        if (mounted) {
          setState(() {
            doctors = loadedDoctors;
            isLoadingDoctors = false;
          });
        }
      });
    } catch (e) {
      print('Error loading doctors: $e');
      if (mounted) {
        setState(() {
          isLoadingDoctors = false;
        });
      }
    }
  }

  Future<void> _loadUserDetails() async {
    try {
      final userDetails = await _appointmentService.getCurrentUserDetails();
      if (userDetails != null && mounted) {
        setState(() {
          nameController.text = userDetails['name'] ?? '';
          if (userDetails['contact'] != null) {
            contactController.text = userDetails['contact'].toString();
          }
          if (userDetails['age'] != null) {
            ageController.text = userDetails['age'].toString();
          }
          if (userDetails['gender'] != null) {
            gender = userDetails['gender'];
          }
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: "Schedule Appointment"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.015,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Patient Details", size),
              textformField("Patient's Name", nameController, size),
              Row(
                children: [
                  Expanded(child: textformField("Age", ageController, size)),
                  SizedBox(width: size.width * 0.02),
                  genderRadio("Male", size),
                  SizedBox(width: size.width * 0.02),
                  genderRadio("Female", size),
                ],
              ),
              textformField(
                "Reason for appointment",
                reasonController,
                size,
                maxLines: 3,
              ),

              SizedBox(height: size.height * 0.02),
              sectionTitle("Doctor Details", size),
              isLoadingDoctors
                  ? const Center(child: CircularProgressIndicator())
                  : doctorDropdownField(
                      "Doctor's Name",
                      doctors,
                      selectedDoctor,
                      (val, id) {
                        setState(() {
                          selectedDoctor = val;
                          selectedDoctorId = id;
                        });
                      },
                      size,
                    ),
              dropdownField(
                "Hospital's Name",
                hospitals,
                selectedHospital,
                (val) => setState(() => selectedHospital = val),
                size,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F3FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Text(
                          selectedDate ?? "Select Date",
                          style: GoogleFonts.poppins(color: Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: dropdownField(
                      "Select Slot",
                      slots,
                      selectedSlot,
                      (val) => setState(() => selectedSlot = val),
                      size,
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.02),
              sectionTitle("Contact Number", size),
              Text(
                "Enter the number on which you wish to receive appointments related information",
                style: GoogleFonts.poppins(fontSize: size.width * 0.03),
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                        vertical: size.height * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F4FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('+91', style: TextStyle(fontSize: size.width * 0.035)),
                    ),
                    SizedBox(width: size.width * 0.01),
                    Expanded(
                      child: TextFormField(
                        controller: contactController,
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter number' : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFE5F4FF),
                          hintText: "00000 00000",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.height * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.02),
              helpCard(size),
              SizedBox(height: size.height * 0.02),

              Center(
                child: isSubmitting
                    ? const CircularProgressIndicator()
                    : ButtonText(
                        horizontalPadding: size.width * 0.02,
                        label: "Schedule Appointment",
                        onPressed: () {
                          if (_formKey.currentState!.validate() && gender != null) {
                            _submitForm();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all the fields."),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: size.width * 0.042,
        ),
      ),
    );
  }

  Widget textformField(
    String hint,
    TextEditingController controller,
    Size size, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) =>
            value == null || value.isEmpty ? 'Please enter $hint' : null,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFE5F4FF),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.015,
          ),
        ),
      ),
    );
  }

  Widget doctorDropdownField(
    String hint,
    List<Map<String, dynamic>> items,
    String? selectedValue,
    Function(String?, String?) onChanged,
    Size size,
  ) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFE3F3FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.015,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select $hint' : null,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item['name'] as String,
                child: Text(
                  "${item['name']} (${item['specialization']})",
                  style: GoogleFonts.poppins(fontSize: size.width * 0.035),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          final selectedItem = items.firstWhere(
            (item) => item['name'] == value,
            orElse: () => {},
          );
          onChanged(value, selectedItem['id']);
        },
      ),
    );
  }

  Widget dropdownField(
    String hint,
    List<String> items,
    String? selectedValue,
    Function(String?) onChanged,
    Size size,
  ) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFE3F3FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.015,
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Please select $hint' : null,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.poppins(fontSize: size.width * 0.035),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget genderRadio(String value, Size size) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: gender,
          onChanged: (val) => setState(() => gender = val),
          activeColor: AppColors.primary,
        ),
        Text(value, style: GoogleFonts.poppins(fontSize: size.width * 0.035)),
      ],
    );
  }

  Widget helpCard(Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: size.width * 0.03),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Need Assistance?",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: size.width * 0.04,
                  ),
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  "Our support team is here to help you with appointment scheduling reach out anytime for quick and reliable assistance!",
                  style: GoogleFonts.poppins(fontSize: size.width * 0.03),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: const Image(
              image: AssetImage("assets/icons/telephone.png"),
              width: 25,
              height: 25,
            ),
          ),
          SizedBox(width: size.width * 0.03),

          Align(
            alignment: Alignment.topCenter,
            child: const Image(
              image: AssetImage("assets/icons/message.png"),
              width: 30,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Create appointment object
      final appointment = AppointmentFirebaseModel(
        patientName: nameController.text,
        patientId: currentUser.uid,
        age: ageController.text,
        gender: gender ?? '',
        reason: reasonController.text,
        doctorName: selectedDoctor ?? '',
        doctorId: selectedDoctorId ?? '',
        hospitalName: selectedHospital ?? '',
        date: selectedDate ?? '',
        slot: selectedSlot ?? '',
        contact: '+91 ${contactController.text}',
        createdAt: DateTime.now(),
      );

      // Save to Firebase
      final appointmentId = await _appointmentService.createAppointment(appointment);

      if (appointmentId != null) {
        // Create data for the next screen
        final data = AppointmentDetailsData(
          name: nameController.text,
          age: ageController.text,
          gender: gender ?? '',
          reason: reasonController.text,
          doctor: selectedDoctor ?? '',
          hospital: selectedHospital ?? '',
          date: selectedDate ?? '',
          slot: selectedSlot ?? '',
          contact: '+91 ${contactController.text}',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment scheduled successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AppointmentDetails(data: data)),
          );
        }
      } else {
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      print('Error submitting form: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }
}
