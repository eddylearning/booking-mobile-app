import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String userName; // Optional: stored for easy admin view
  final List<Map<String, dynamic>> products;
  final double totalAmount;
  final String status; // pending, paid, delivered
  final String paymentMethod; // M-Pesa
  final Timestamp timestamp;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.timestamp,
  });

  // Create from Firestore Document
  factory OrderModel.fromDocument(String id, Map<String, dynamic> doc) {
    return OrderModel(
      orderId: id,
      userId: doc['userId'] ?? '',
      userName: doc['userName'] ?? 'Unknown',
      products: List<Map<String, dynamic>>.from(doc['products'] ?? []),
      totalAmount: (doc['totalAmount'] is num) ? (doc['totalAmount'] as num).toDouble() : 0.0,
      status: doc['status'] ?? 'pending',
      paymentMethod: doc['paymentMethod'] ?? 'unknown',
      timestamp: doc['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'products': products,
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'timestamp': timestamp,
    };
  }
}