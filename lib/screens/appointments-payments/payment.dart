import 'package:flutter/material.dart';
import 'package:MedicalShala/theme/app_colors.dart';
import 'package:MedicalShala/widgets/overview-widgets/Button_text.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Credit Card';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  final borderRadius = BorderRadius.circular(12);

 Widget _paymentMethodButton(String label, IconData? icon, {Widget? image}) {
  final isSelected = selectedMethod == label;
  return Expanded(
    child: GestureDetector(
      onTap: () => setState(() => selectedMethod = label),
      child: Container(
        padding: const EdgeInsets.all(13),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : const Color.fromARGB(255, 181, 179, 179),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: borderRadius,
          color: isSelected ? const Color(0xFFE6F1FF) : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image ??
                Icon(icon, size: 30, color: isSelected ? Colors.black : Colors.grey),
            const SizedBox(height: 8),
            Center(
              child: Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Secure Your Payments Seamlessly",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Complete the transaction through our encrypted payment gateway to ensure maximum safety.",
              style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
            ),
            const SizedBox(height: 20),
            const Text(
              "BILLED TO",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            // Name input
            TextField(
              
              controller: nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(6),
                hintText: 'Enter your name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "PAYMENT METHOD",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Payment options
            Row(
              
              children: [
                _paymentMethodButton('Credit Card',  null,
                  image: Image.asset('assets/icons/creditcard.png', height: 24),),
                _paymentMethodButton('Bank Transfer',  null,
                  image: Image.asset('assets/icons/bank.png', height: 22),),
                _paymentMethodButton(
                  'UPI Payments',
                  null,
                  image: Image.asset('assets/icons/upi.png', height: 18),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Credit card number field
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(
                hintText: '1234 1234 1234',
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset('assets/icons/creditcard.png', height: 20),
                ),
                border: OutlineInputBorder(borderRadius: borderRadius),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            // MM/YY and CVC
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryController,
                    decoration: InputDecoration(
                      hintText: 'MM / YY',
                      border: OutlineInputBorder(borderRadius: borderRadius),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: cvcController,
                    decoration: InputDecoration(
                      hintText: 'CVC',
                      border: OutlineInputBorder(borderRadius: borderRadius),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],

            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ButtonText(label: "Cancel", 
                horizontalPadding: 24,
                  onPressed: () {
                    // Handle cancel logic here
                    Navigator.pop(context);
                  }
                ),
                ButtonText(label: "Proceed to Pay", 
                horizontalPadding: 24,
                  onPressed: () {
                    // Handle payment logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment Successful!')),
                    );
                  }
                ),
              ],
            )
          ],
          
        ),
      ),
    );
  }
}
