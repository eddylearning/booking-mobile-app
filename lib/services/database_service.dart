
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

//   // Fetch all products (Customer - Real-time)
//   Stream<QuerySnapshot> getProductsStream() {
//     return _productsCollection.orderBy('name').snapshots();
//   }

//   // Fetch products for Admin (Real-time) ✅ FIXED (Option A)
//   Stream<QuerySnapshot> fetchProductsForAdmin() {
//     return _productsCollection.orderBy('name').snapshots();
//   }

//   // Add Product (Admin)
//   Future<void> addProduct(Map<String, dynamic> productData) async {
//     await _productsCollection.add(productData);
//   }

//   // Update Product (Admin)
//   Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
//     await _productsCollection.doc(productId).update(data);
//   }

//   // Delete Product (Admin)
//   Future<void> deleteProduct(String productId) async {
//     await _productsCollection.doc(productId).delete();
//   }

//   // --- ORDER METHODS ---

//   Future<String> placeOrder(Map<String, dynamic> orderData) async {
//     var docRef = await _ordersCollection.add(orderData);
//     return docRef.id;
//   }

//   Stream<QuerySnapshot> getUserOrders(String userId) {
//     return _ordersCollection
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   Stream<QuerySnapshot> getAllOrders() {
//     return _ordersCollection
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   Future<void> updateOrderStatus(String orderId, String newStatus) async {
//     await _ordersCollection.doc(orderId).update({'status': newStatus});
//   }

//   // --- USER METHODS ---

//   Future<void> saveUserData(String uid, String email, String name) async {
//     await _usersCollection.doc(uid).set({
//       'uid': uid,
//       'email': email,
//       'username': name,
//       'role': 'customer',
//       'createdAt': DateTime.now(),
//     });
//   }

//   Future<void> updateUserProfile(Map<String, dynamic> data) async {
//     final uid = _auth.currentUser?.uid;
//     if (uid != null) {
//       await _usersCollection.doc(uid).update(data);
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_farm_app/models/cart_model.dart'; // Import CartModel

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

  Stream<QuerySnapshot> getProductsStream() {
    return _productsCollection.orderBy('name').snapshots();
  }

  Stream<QuerySnapshot> fetchProductsForAdmin() {
    return _productsCollection.orderBy('name').snapshots();
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _productsCollection.add(productData);
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    await _productsCollection.doc(productId).update(data);
  }

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
      'userCart': [], // Initialize empty cart
      'userWish': [],
    });
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _usersCollection.doc(uid).update(data);
    }
  }

  // --- CART PERSISTENCE METHODS (NEW) ---

  /// 1. Save Cart: Converts Map to List and saves to Firestore
  Future<void> updateUserCart(String userId, Map<String, CartModel> cartItems) async {
    try {
      // Convert the Map of CartModels to a List of Maps (what Firestore expects)
      final cartList = cartItems.values.map((cartItem) => cartItem.toMap()).toList();

      await _usersCollection.doc(userId).update({'userCart': cartList});
    } catch (e) {
      print("Error saving cart: $e");
    }
  }

  /// 2. Fetch Cart: Retrieves List from Firestore and converts to Map
  Future<Map<String, CartModel>> fetchUserCart(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return {};

      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> cartList = data['userCart'] ?? [];

      // Convert List back to Map<String, CartModel>
      Map<String, CartModel> cartMap = {};
      for (var item in cartList) {
        final cartModel = CartModel.fromMap(item);
        // Use the Product ID as the key
        cartMap[cartModel.product.id] = cartModel;
      }
      return cartMap;
    } catch (e) {
      print("Error fetching cart: $e");
      return {};
    }
  }
}