// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DatabaseService {
//   // Singleton pattern
//   static final DatabaseService instance = DatabaseService._internal();
//   DatabaseService._internal();

//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Collection References
//   CollectionReference get _productsCollection => _db.collection('products');
//   CollectionReference get _ordersCollection => _db.collection('orders');
//   CollectionReference get _usersCollection => _db.collection('users');

//   // --- PRODUCT METHODS ---

//   // Fetch all products (Real-time stream)
//   Stream<QuerySnapshot> getProductsStream() {
//     return _productsCollection.orderBy('name', descending: false).snapshots();
//   }

//   // Fetch products for Admin (Static fetch)
//   Future<List<QueryDocumentSnapshot>> fetchProductsForAdmin() async {
//     var snapshot = await _productsCollection.get();
//     return snapshot.docs;
//   }

//   // Add Product (Admin)
//   Future<void> addProduct(Map<String, dynamic> productData) async {
//     try {
//       await _productsCollection.add(productData);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Update Product (Admin)
//   Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
//     try {
//       await _productsCollection.doc(productId).update(data);
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Delete Product (Admin)
//   Future<void> deleteProduct(String productId) async {
//     try {
//       await _productsCollection.doc(productId).delete();
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // --- ORDER METHODS ---

//   // Place an order
//   Future<String> placeOrder(Map<String, dynamic> orderData) async {
//     try {
//       var docRef = await _ordersCollection.add(orderData);
//       return docRef.id; // Return Order ID
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // Fetch User Orders
//   Stream<QuerySnapshot> getUserOrders(String userId) {
//     return _ordersCollection
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   // Fetch All Orders (Admin)
//   Stream<QuerySnapshot> getAllOrders() {
//     return _ordersCollection.orderBy('timestamp', descending: true).snapshots();
//   }

//   // Update Order Status (Admin)
//   Future<void> updateOrderStatus(String orderId, String newStatus) async {
//     try {
//       await _ordersCollection.doc(orderId).update({'status': newStatus});
//     } catch (e) {
//       rethrow;
//     }
//   }

//   // --- USER METHODS ---

//   // Save user data to Firestore on Sign Up
//   Future<void> saveUserData(String uid, String email, String name) async {
//     try {
//       await _usersCollection.doc(uid).set({
//         'uid': uid,
//         'email': email,
//         'username': name,
//         'role': 'customer', // Default role
//         'createdAt': DateTime.now(),
//       });
//     } catch (e) {
//       rethrow;
//     }
//   }
  
//   // Update User Profile
//   Future<void> updateUserProfile(Map<String, dynamic> data) async {
//     String? uid = _auth.currentUser?.uid;
//     if (uid != null) {
//       await _usersCollection.doc(uid).update(data);
//     }
//   }
// }

// //getter in DatabaseService if accessing collection directly in Provider
//   // CollectionReference get _usersCollection => db.collection('users');

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection References
  CollectionReference get _productsCollection => _db.collection('products');
  CollectionReference get _ordersCollection => _db.collection('orders');
  CollectionReference get _usersCollection => _db.collection('users');

  // --- PRODUCT METHODS ---

  // Fetch all products (Customer - Real-time)
  Stream<QuerySnapshot> getProductsStream() {
    return _productsCollection.orderBy('name').snapshots();
  }

  // Fetch products for Admin (Real-time) ✅ FIXED (Option A)
  Stream<QuerySnapshot> fetchProductsForAdmin() {
    return _productsCollection.orderBy('name').snapshots();
  }

  // Add Product (Admin)
  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _productsCollection.add(productData);
  }

  // Update Product (Admin)
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    await _productsCollection.doc(productId).update(data);
  }

  // Delete Product (Admin)
  Future<void> deleteProduct(String productId) async {
    await _productsCollection.doc(productId).delete();
  }

  // --- ORDER METHODS ---

  Future<String> placeOrder(Map<String, dynamic> orderData) async {
    var docRef = await _ordersCollection.add(orderData);
    return docRef.id;
  }

  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllOrders() {
    return _ordersCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _ordersCollection.doc(orderId).update({'status': newStatus});
  }

  // --- USER METHODS ---

  Future<void> saveUserData(String uid, String email, String name) async {
    await _usersCollection.doc(uid).set({
      'uid': uid,
      'email': email,
      'username': name,
      'role': 'customer',
      'createdAt': DateTime.now(),
    });
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _usersCollection.doc(uid).update(data);
    }
  }
}
