import 'package:flutter/foundation.dart';
import 'package:fresh_farm_app/services/database_service.dart';

class ProductProvider extends ChangeNotifier {
  // ----------------------------------------
  // ADMIN: MANAGE PRODUCTS CRUD
  // ----------------------------------------

  /// Add a new product to Firestore
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      await DatabaseService.instance.addProduct(productData);
      if (kDebugMode) print("Product added successfully");
      // No need to notifyListeners if UI uses StreamBuilder, 
      // but keeping it here allows future state management if needed.
    } catch (e) {
      if (kDebugMode) print("Error adding product: $e");
      rethrow;
    }
  }

  /// Update an existing product
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    try {
      await DatabaseService.instance.updateProduct(productId, data);
      if (kDebugMode) print("Product updated successfully");
    } catch (e) {
      if (kDebugMode) print("Error updating product: $e");
      rethrow;
    }
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await DatabaseService.instance.deleteProduct(productId);
      if (kDebugMode) print("Product deleted successfully");
    } catch (e) {
      if (kDebugMode) print("Error deleting product: $e");
      rethrow;
    }
  }

  // ----------------------------------------
  // SINGLE PRODUCT STATE (For Details Screen)
  // ----------------------------------------
  
  // Holds the currently selected product for the Detail Screen
  Map<String, dynamic>? _selectedProduct;
  Map<String, dynamic>? get getSelectedProduct => _selectedProduct;

  void setSelectedProduct(Map<String, dynamic> product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}