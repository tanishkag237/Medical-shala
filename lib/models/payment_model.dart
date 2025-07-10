// models/payment_model.dart

import 'package:flutter/material.dart';

class PaymentData {
  final double totalRevenue;
  final double previousRevenue;
  final double revenueGrowth;
  final double netProfit;
  final double netProfitGrowth;
  final int totalPatients;
  final double patientGrowth;
  final double completedPayment;
  final double pendingPayment;
  final double refundedAmount;
  final List<RevenueAnalysis> revenueAnalysis;
  final List<PaymentMode> paymentModes;
  final String dateRange;

  PaymentData({
    required this.totalRevenue,
    required this.previousRevenue,
    required this.revenueGrowth,
    required this.netProfit,
    required this.netProfitGrowth,
    required this.totalPatients,
    required this.patientGrowth,
    required this.completedPayment,
    required this.pendingPayment,
    required this.refundedAmount,
    required this.revenueAnalysis,
    required this.paymentModes,
    required this.dateRange,
  });
}

class RevenueAnalysis {
  final String day;
  final double amount;

  RevenueAnalysis({
    required this.day,
    required this.amount,
  });
}

class PaymentMode {
  final String mode;
  final double percentage;
  final Color color;

  PaymentMode({
    required this.mode,
    required this.percentage,
    required this.color,
  });
}