import 'package:flutter/material.dart';

import '../../widgets/overview-widgets/custom_app_bar.dart';

class PrescriptionScreen extends StatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  String gender = '';
  String followUp = 'None';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  const CustomAppBar(title: "Prescription"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Doctor Details'),
            _textField('Doctor’s Name'),
            const SizedBox(height: 10),
            _textField('Hospital’s Name'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _textField('dd/mm/yyyy')),
                const SizedBox(width: 10),
                const Text('Time'),
                const SizedBox(width: 6),
                _timeField('00'),
                const Text(':'),
                _timeField('00'),
                const SizedBox(width: 4),
                const Text('AM PM')
              ],
            ),

            const SizedBox(height: 20),
            const SectionTitle(title: 'Patient Details'),
            _textField('Patient’s Name'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _textField('Age')),
                const SizedBox(width: 10),
                _genderOption('Male'),
                _genderOption('Female'),
              ],
            ),
            const SizedBox(height: 10),
            _textField('Reason for patient visit', maxLines: 3),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SectionTitle(title: 'Medication Details'),
                Icon(Icons.add_circle_outline)
              ],
            ),
            _textField('Medication Recommendation'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _textField('0')),
                const SizedBox(width: 8),
                const Text('days')
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _textField('0 - 0 - 0')),
                _mealOption('After Meal'),
                _mealOption('Before Meal')
              ],
            ),
            const SizedBox(height: 10),
            _textField('Notes', maxLines: 3),

            const SizedBox(height: 20),
            const SectionTitle(title: 'Follow-up Appointment'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in [
                  'None',
                  'After 3 days',
                  'After a week',
                  'After 2 weeks',
                  'After a month',
                  'Customize'
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: followUp == label,
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: followUp == label ? Colors.white : Colors.blue,
                    ),
                    backgroundColor: Colors.transparent,
                    shape: StadiumBorder(side: BorderSide(color: Colors.blue)),
                    onSelected: (_) => setState(() => followUp = label),
                  )
              ],
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text('Save', style: TextStyle(color: Colors.black54)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint, {int maxLines = 1}) => TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFE5F4FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget _timeField(String hint) => SizedBox(
        width: 40,
        child: _textField(hint),
      );

  Widget _genderOption(String value) => Row(
        children: [
          Radio(
            value: value,
            groupValue: gender,
            onChanged: (val) => setState(() => gender = val!),
          ),
          Text(value)
        ],
      );

  Widget _mealOption(String label) => Row(
        children: [
          Radio(
            value: label,
            groupValue: '',
            onChanged: (val) {},
          ),
          Text(label)
        ],
      );
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
