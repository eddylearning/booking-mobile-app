// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart'; // FIXED: Use main widgets import
// // import 'package:uuid/uuid.dart'; // Add this to pubspec.yaml if you want to generate IDs here

// class PaymentService {
//   static final PaymentService instance = PaymentService._internal();
//   PaymentService._internal();

//   final FirebaseFunctions _functions = FirebaseFunctions.instance;
//   // final _uuid = const Uuid();

//   /// Helper to standardize phone numbers for M-Pesa (format: 2547XXXXXXXX)
//   String _formatPhoneNumber(String phone) {
//     // Remove all non-numeric characters (spaces, dashes, plus signs)
//     String formatted = phone.replaceAll(RegExp(r'[^0-9]'), '');

//     // Case 1: User enters 0712345678 -> Convert to 254712345678
//     if (formatted.startsWith('0')) {
//       return '254${formatted.substring(1)}';
//     }
//     // Case 2: User enters +254712345678 -> Convert to 254712345678
//     else if (formatted.startsWith('+254')) {
//       return formatted.substring(1); // Remove the '+'
//     }
//     // Case 3: User enters 254712345678 -> Keep as is
//     else if (formatted.startsWith('254')) {
//       return formatted;
//     }

//     // Fallback: Return cleaned number (might fail at API if invalid)
//     return formatted;
//   }

//   /// Initiates the M-Pesa STK Push
//   Future<Map<String, dynamic>> initiateSTKPush({
//     required int amount,
//     required String phone,
//     required String orderId,
//   }) async {
//     try {
//       final String formattedPhone = _formatPhoneNumber(phone);

//       if (kDebugMode) {
//         print("Initiating Payment: Amount $amount, Phone $formattedPhone, OrderID $orderId");
//       }

//       // Call the Cloud Function 'initiateSTKPush' defined in your backend
//       final HttpsCallableResult result = await _functions.httpsCallable(
//         'initiateSTKPush',
//       ).call({
//         'amount': amount,
//         'phone': formattedPhone, // The index.js expects 'phone'
//         'orderId': orderId,
//       });

//       return {'success': true, 'data': result.data};
//     } on FirebaseFunctionsException catch (e) {
//       String errorMessage = e.message ?? "Unknown payment error";
//       // If it's a 'permission-denied' or 'not-found' error, the function might not be deployed
//       if (e.code == 'not-found') {
//         errorMessage = "Payment function not found. Ensure backend is deployed.";
//       }
//       return {'success': false, 'message': errorMessage};
//     } catch (e) {
//       if (kDebugMode) {
//         print("Payment Service Error: $e");
//       }
//       return {'success': false, 'message': 'An unknown error occurred.'};
//     }
//   }

//   /// Public method for Checkout Screen to call
//   static Future<void> processMpesaPayment({
//     required num amount, // Changed to 'num' to handle both int/double from cart
//     required String phone,
//     required String orderId, // ADDED: We need an OrderID to track payment
//     required BuildContext context,
//     required VoidCallback onSuccess, // Fixed: Changed Null Function() to VoidCallback
//   }) async {
//     // Show a loading indicator (Optional, usually handled in UI state, but good for feedback)
//     // ScaffoldMessenger.of(context).showSnackBar(...);

//     final result = await instance.initiateSTKPush(
//       amount: amount.toInt(), // M-Pesa API expects integer (no decimals like 10.50)
//       phone: phone,
//       orderId: orderId,
//     );

//     if (!context.mounted) return;

//     if (result['success'] == true) {
//       // SUCCESS: STK Push sent
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("M-Pesa prompt sent! Please check your phone."),
//           backgroundColor: Colors.green,
//         ),
//       );
      
//       // Call the success callback (Navigate to orders / clear cart)
//       onSuccess();
//     } else {
//       // FAILURE: Error occurred
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result['message'] ?? "Payment failed"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  // REPLACE THIS with your current Ngrok URL from Terminal 2
  // static const String _baseUrl = "https://0daa97004193.ngrok-free.app";
    static const String _baseUrl = "http://localhost:5000";

  static final PaymentService instance = PaymentService._internal();
  PaymentService._internal();

  /// Helper to standardize phone numbers for M-Pesa (format: 2547XXXXXXXX)
  String _formatPhoneNumber(String phone) {
    String formatted = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (formatted.startsWith('0')) {
      return '254${formatted.substring(1)}';
    } else if (formatted.startsWith('+254')) {
      return formatted.substring(1);
    } else if (formatted.startsWith('254')) {
      return formatted;
    }
    return formatted;
  }

  /// Initiates the M-Pesa STK Push
  Future<Map<String, dynamic>> initiateSTKPush({
    required int amount,
    required String phone,
    required String orderId,
  }) async {
    try {
      final String formattedPhone = _formatPhoneNumber(phone);

      if (kDebugMode) {
        print("Initiating Payment: Amount $amount, Phone $formattedPhone, OrderID $orderId");
      }

      // Call your local Express Server
      // final response = await http.post(
      //   Uri.parse('$_baseUrl/initiate-stk-push'),
      //   headers: {'Content-Type': 'application/json'},
       final response = await http.post(
        Uri.parse('$_baseUrl/initiate-stk-push'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true', // 3. ADDED: Essential header for Ngrok
        },
        body: jsonEncode({
          'amount': amount,
          'phone': formattedPhone,
          'orderId': orderId,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false, 
          'message': responseData['error'] ?? "Server error"
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("Payment Service Error: $e");
      }
      return {'success': false, 'message': 'Failed to connect to server. Is it running?'};
    }
  }

  /// Public method for Checkout Screen
  static Future<void> processMpesaPayment({
    required num amount,
    required String phone,
    required String orderId,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    final result = await instance.initiateSTKPush(
      amount: amount.toInt(),
      phone: phone,
      orderId: orderId,
    );

    if (!context.mounted) return;

    if (result['success'] == true) {
      // SUCCESS: STK Push sent
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("M-Pesa prompt sent! Please check your phone."),
          backgroundColor: Colors.green,
        ),
      );
      onSuccess();
    } else {
      // FAILURE
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Payment failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}