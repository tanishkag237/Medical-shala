// data/payment_dummy_data.dart
import 'package:flutter/material.dart';
import '../models/payment_model.dart';

class PaymentDummyData {
  static PaymentData getPaymentData() {
    return PaymentData(
      totalRevenue: 250000,
      previousRevenue: 200000,
      revenueGrowth: 25.0,
      netProfit: 150000,
      netProfitGrowth: 25.0,
      totalPatients: 30756,
      patientGrowth: 15.0,
      completedPayment: 150000,
      pendingPayment: 30000,
      refundedAmount: 10000,
      dateRange: "Last 30 days",
      revenueAnalysis: [
        RevenueAnalysis(day: "Mon", amount: 30000),
        RevenueAnalysis(day: "Tue", amount: 28000),
        RevenueAnalysis(day: "Wed", amount: 35000),
        RevenueAnalysis(day: "Thu", amount: 25000),
        RevenueAnalysis(day: "Fri", amount: 35000),
        RevenueAnalysis(day: "Sat", amount: 20000),
        RevenueAnalysis(day: "Sun", amount: 18000),
      ],
      paymentModes: [
        PaymentMode(
          mode: "Cash Payment",
          percentage: 22.0,
          color: const Color(0xFF2196F3),
        ),
        PaymentMode(
          mode: "Credit/Debit Card",
          percentage: 28.0,
          color: const Color(0xFF2196F3),
        ),
        PaymentMode(
          mode: "UPI Payment",
          percentage: 37.0,
          color: const Color(0xFF2196F3),
        ),
        PaymentMode(
          mode: "Net Banking",
          percentage: 13.0,
          color: const Color(0xFF2196F3),
        ),
      ],
    );
  }
}