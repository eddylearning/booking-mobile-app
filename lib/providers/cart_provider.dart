
// import 'package:flutter/foundation.dart';
// import 'package:fresh_farm_app/models/cart_model.dart';
// import 'package:fresh_farm_app/models/product_model.dart';

// class CartProvider extends ChangeNotifier {
//   // Map: ProductID -> CartModel
//   final Map<String, CartModel> _items = {};

//   /// Backward compatibility (older files may still use this)
//   Map<String, CartModel> get getCartItems => _items;

//   /// Correct getter (DO NOT return null)
//   Map<String, CartModel> get cartItems => _items;

//   // ---------------- TOTALS ----------------

//   /// Total cart amount
//   double getTotal(Map<String, CartModel> cartItems) {
//     double total = 0.0;
//     for (final item in cartItems.values) {
//       total += item.product.price * item.quantity;
//     }
//     return total;
//   }

//   /// Total quantity (badge count)
//   int get totalQty {
//     int total = 0;
//     for (final item in _items.values) {
//       total += item.quantity;
//     }
//     return total;
//   }

//   /// Convenience getter
//   double get totalAmount => getTotal(_items);

//   // ---------------- CART ACTIONS ----------------

//   /// Add product to cart (ProductModel-based)
//   void addProductToCart({
//     required ProductModel product,
//   }) {
//     if (_items.containsKey(product.id)) {
//       _items.update(
//         product.id,
//         (existingItem) => CartModel(
//           product: existingItem.product,
//           quantity: existingItem.quantity + 1,
//         ),
//       );
//     } else {
//       _items[product.id] = CartModel(
//         product: product,
//         quantity: 1,
//       );
//     }

//     notifyListeners();
//     _syncCartWithFirestore();
//   }

//   /// Remove one quantity
//   void removeOneItem(String productId) {
//     if (!_items.containsKey(productId)) return;

//     final existingItem = _items[productId]!;

//     if (existingItem.quantity > 1) {
//       _items.update(
//         productId,
//         (_) => CartModel(
//           product: existingItem.product,
//           quantity: existingItem.quantity - 1,
//         ),
//       );
//     } else {
//       _items.remove(productId);
//     }

//     notifyListeners();
//     _syncCartWithFirestore();
//   }

//   /// Remove product completely
//   void removeProductFromCart(String productId) {
//     _items.remove(productId);
//     notifyListeners();
//     _syncCartWithFirestore();
//   }

//   /// Clear cart after checkout
//   void clearCart() {
//     _items.clear();
//     notifyListeners();
//     _syncCartWithFirestore();
//   }

//   /// Restore cart from Firestore
//   void setCartItems(Map<String, CartModel> loadedItems) {
//     _items
//       ..clear()
//       ..addAll(loadedItems);
//     notifyListeners();
//   }

//   // ---------------- FIRESTORE SYNC ----------------

//   Future<void> _syncCartWithFirestore() async {
//     // TODO: DatabaseService.updateUserCart(userId, _items)
//     if (kDebugMode) {
//       print("Cart synced. Items: ${_items.length}");
//     }
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
import 'package:fresh_farm_app/models/cart_model.dart';
import 'package:fresh_farm_app/models/product_model.dart';
import 'package:fresh_farm_app/services/database_service.dart'; // Import DB Service

class CartProvider extends ChangeNotifier {
  final Map<String, CartModel> _items = {};

  Map<String, CartModel> get getCartItems => _items;
  Map<String, CartModel> get cartItems => _items;

  double getTotal(Map<String, CartModel> cartItems) {
    double total = 0.0;
    for (final item in cartItems.values) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  int get totalQty {
    int total = 0;
    for (final item in _items.values) {
      total += item.quantity;
    }
    return total;
  }

  double get totalAmount => getTotal(_items);

  void addProductToCart({required ProductModel product}) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartModel(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items[product.id] = CartModel(
        product: product,
        quantity: 1,
      );
    }

    notifyListeners();
    _syncCartWithFirestore();
  }

  void removeOneItem(String productId) {
    if (!_items.containsKey(productId)) return;

    final existingItem = _items[productId]!;

    if (existingItem.quantity > 1) {
      _items.update(
        productId,
        (_) => CartModel(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
    _syncCartWithFirestore();
  }

  void removeProductFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
    _syncCartWithFirestore();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _syncCartWithFirestore();
  }

  void setCartItems(Map<String, CartModel> loadedItems) {
    _items
      ..clear()
      ..addAll(loadedItems);
    notifyListeners();
  }

  // --- FIRESTORE SYNC IMPLEMENTATION ---

  Future<void> _syncCartWithFirestore() async {
    // Get current logged in user ID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Call the service to save the map
      await DatabaseService.instance.updateUserCart(user.uid, _items);
    } catch (e) {
      if (kDebugMode) print("Error syncing cart: $e");
    }
  }

  /// NEW: Fetch Cart on App Start
  Future<void> fetchCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final loadedCart = await DatabaseService.instance.fetchUserCart(user.uid);
      setCartItems(loadedCart);
    } catch (e) {
      if (kDebugMode) print("Error fetching cart: $e");
    }
  }
}