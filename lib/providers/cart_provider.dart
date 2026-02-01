// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// import 'package:fresh_farm_app/services/database_service.dart';

class CartProvider extends ChangeNotifier {
  // We store cart items as a List of Maps: [{'id': ..., 'qty': ...}]
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get getCartItems => _cartItems;

  // Get the total price of all items in the cart
  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += (item['price'] as double) * (item['qty'] as int);
    }
    return total;
  }

  // Get total number of items
  int get totalQty {
    int total = 0;
    for (var item in _cartItems) {
      total += (item['qty'] as int);
    }
    return total;
  }

  // Initialize Cart with user data from Firestore
  void setCartItems(List<dynamic> userCart) {
    // Convert dynamic list to proper Map list
    _cartItems = userCart
        .map((item) => item as Map<String, dynamic>)
        .toList();
    notifyListeners();
  }

  // --- CART OPERATIONS ---

  /// Add or Update Product in Cart
  Future<void> addProductToCart({
    required String productId,
    required String title,
    required double price,
    required String image,
  }) async {
    // Check if item already exists
    int index = _cartItems.indexWhere((item) => item['id'] == productId);

    if (index != -1) {
      // Update quantity
      _cartItems[index]['qty']++;
    } else {
      // Add new item
      _cartItems.add({
        'id': productId,
        'name': title,
        'price': price,
        'image': image,
        'qty': 1,
      });
    }

    notifyListeners();
    await _syncCartWithFirestore();
  }

  /// Remove Product from Cart
  Future<void> removeProductFromCart(String productId) async {
    _cartItems.removeWhere((item) => item['id'] == productId);
    notifyListeners();
    await _syncCartWithFirestore();
  }

  /// Update Quantity manually
  Future<void> updateQuantity(String productId, int newQty) async {
    if (newQty <= 0) {
      await removeProductFromCart(productId);
      return;
    }

    int index = _cartItems.indexWhere((item) => item['id'] == productId);
    if (index != -1) {
      _cartItems[index]['qty'] = newQty;
      notifyListeners();
      await _syncCartWithFirestore();
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    _cartItems = [];
    notifyListeners();
    await _syncCartWithFirestore();
  }

  // --- SYNC WITH FIRESTORE ---

  /// Saves the current local cart to the User's Firestore document
  Future<void> _syncCartWithFirestore() async {
    try {
      // Call DB Service to update user cart
      // Note: You need to add this method to DatabaseService if it's not there
      // or access Firestore directly here. I'll use DatabaseService concept.
      
      // For now, assuming we update the UserProvider to trigger a save
      // Ideally, this calls DatabaseService.updateUserCart(userId, _cartItems);
      
      // Implementing the direct Firestore call here to avoid circular deps
      // (Assuming UserProvider holds the UID, but we can get it from Auth)
      // For this demo, we assume the caller handles persistence or we add a method to DB Service.
      
      if (kDebugMode) {
        print("Cart updated. Syncing to Firestore...");
      }
      
      // TODO: You must call DatabaseService.updateUserCart(userId, _cartItems) 
      // inside your checkout or add method.
      
    } catch (e) {
      if (kDebugMode) {
        print("Error syncing cart: $e");
      }
    }
  }
}