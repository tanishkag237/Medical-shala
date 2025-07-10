import 'package:flutter/material.dart';
import 'package:medshala/screens/appointments-payments/payment.dart';
import 'package:medshala/widgets/Button_text.dart';
import '../../models/appointment_details_data.dart';

class AppointmentDetails extends StatefulWidget {
  final AppointmentDetailsData data;
  const AppointmentDetails({super.key, required this.data});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(color: Colors.grey.shade700, fontSize: 14);
    final valueStyle = const TextStyle(color: Colors.black, fontSize: 14);
    final size = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Appointment Details",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Booking Details"),
        
              sectionDivider("PATIENT DETAILS"),
              detailRow("Name", widget.data.name, labelStyle, valueStyle),
              detailRow("Age", widget.data.age, labelStyle, valueStyle),
              detailRow("Gender", widget.data.gender, labelStyle, valueStyle),
              detailRow("Contact Number", widget.data.contact, labelStyle, valueStyle),
        
              const SizedBox(height: 12),
              sectionDivider("DOCTOR DETAILS"),
              detailRow("Doctor’s Name", widget.data.doctor, labelStyle, valueStyle),
              detailRow("Hospital’s Name", widget.data.hospital, labelStyle, valueStyle),
              detailRow("Date & Slot", "${widget.data.date} & ${widget.data.slot}", labelStyle, valueStyle),
        
              const SizedBox(height: 12),
              sectionDivider("BILL DETAILS"),
              detailRow("Consultation Fee", "Rs.500", labelStyle, valueStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              )),
        
              SizedBox(height: size * 0.3),
        
              Center(
                child: ButtonText(label: "Proceed Payment", onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                }),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget sectionDivider(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: Colors.grey, thickness: 1)),
      ],
    );
  }

  Widget detailRow(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: labelStyle),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
