// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:flutter/foundation.dart';

// class PaymentService {
//   static final PaymentService instance = PaymentService._internal();
//   PaymentService._internal();

//   final FirebaseFunctions _functions = FirebaseFunctions.instance;

//   /// Initiates the M-Pesa STK Push
//   /// [amount] - The amount to pay
//   /// [phone] - The phone number (format: 07... or 2547...)
//   /// [orderId] - The order ID to attach to the transaction
//   Future<Map<String, dynamic>> initiateSTKPush({
//     required int amount,
//     required String phone,
//     required String orderId,
//   }) async {
//     try {
//       // Call the Cloud Function 'initiateSTKPush' defined in your backend
//       final HttpsCallableResult result = await _functions.httpsCallable(
//         'initiateSTKPush',
//       ).call({
//         'amount': amount,
//         'phone': phone,
//         'orderId': orderId,
//       });

//       return {'success': true, 'data': result.data};
//     } on FirebaseFunctionsException catch (e) {
//       // Handle specific Firebase Function errors
//       return {'success': false, 'message': e.message};
//     } catch (e) {
//       if (kDebugMode) {
//         print("Payment Service Error: $e");
//       }
//       return {'success': false, 'message': 'An unknown error occurred.'};
//     }
//   }
// }

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class PaymentService {
  static final PaymentService instance = PaymentService._internal();
  PaymentService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Helper to standardize phone numbers for M-Pesa (format: 2547XXXXXXXX)
  String _formatPhoneNumber(String phone) {
    // Remove all non-numeric characters (spaces, dashes, plus signs)
    String formatted = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Case 1: User enters 0712345678 -> Convert to 254712345678
    if (formatted.startsWith('0')) {
      return '254${formatted.substring(1)}';
    }
    // Case 2: User enters +254712345678 -> Convert to 254712345678
    else if (formatted.startsWith('+254')) {
      return formatted.substring(1); // Remove the '+'
    }
    // Case 3: User enters 254712345678 -> Keep as is
    else if (formatted.startsWith('254')) {
      return formatted;
    }

    // Fallback: Return cleaned number (might fail at API if invalid)
    return formatted;
  }

  /// Initiates the M-Pesa STK Push
  /// [amount] - The amount to pay
  /// [phone] - The phone number (any format: 07... or 2547...)
  /// [orderId] - The order ID to attach to the transaction
  Future<Map<String, dynamic>> initiateSTKPush({
    required int amount,
    required String phone,
    required String orderId,
  }) async {
    try {
      // Standardize the phone number before sending to backend
      final String formattedPhone = _formatPhoneNumber(phone);

      if (kDebugMode) {
        print("Initiating Payment: Amount $amount, Phone $formattedPhone");
      }

      // Call the Cloud Function 'initiateSTKPush' defined in your backend
      final HttpsCallableResult result = await _functions.httpsCallable(
        'initiateSTKPush',
      ).call({
        'amount': amount,
        'phone': formattedPhone,
        'orderId': orderId,
      });

      return {'success': true, 'data': result.data};
    } on FirebaseFunctionsException catch (e) {
      // Handle specific Firebase Function errors
      String errorMessage = e.message ?? "Unknown payment error";
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      if (kDebugMode) {
        print("Payment Service Error: $e");
      }
      return {'success': false, 'message': 'An unknown error occurred.'};
    }
  }
}