// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'product_model.dart';

// class CartModel {
//   // Storing the Product object directly is better than Maps
//   final ProductModel product;
//   int quantity;

//   CartModel({
//     required this.product,
//     this.quantity = 1,
//   });

//   double get totalPrice => product.price * quantity;

//   // To store in Firestore (converting object to map)
//   Map<String, dynamic> toMap() {
//     return {
//       'id': product.id,
//       'name': product.name,
//       'price': product.price,
//       'image': product.imageUrl,
//       'qty': quantity,
//     };
//   }

//   // To retrieve from Firestore
//   factory CartModel.fromMap(Map<String, dynamic> map) {
//     return CartModel(
//       product: ProductModel(
//         id: map['id'],
//         name: map['name'],
//         category: '',
//         price: map['price'].toDouble(),
//         description: '',
//         imageUrl: map['image'],
//         stock: 0, createdAt: Timestamp.now(),
//         // createdAt: Timestamp.now (), // Not needed for cart item
//       ),
//       quantity: map['qty'] ?? 1,
//     );
//   }

//   get price => null;
 
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class CartModel {
  // Store the Product directly
  final ProductModel product;
  int quantity;

  CartModel({
    required this.product,
    this.quantity = 1,
  });

  /// Total price for this cart item
  double get totalPrice => product.price * quantity;

  /// Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'image': product.imageUrl,
      'qty': quantity,
    };
  }

  /// Create CartModel from Firestore map
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      product: ProductModel(
        id: map['id'],
        name: map['name'],
        category: '',
        price: (map['price'] as num).toDouble(),
        description: '',
        imageUrl: map['image'],
        stock: 0,
        createdAt: Timestamp.now(),
      ),
      quantity: map['qty'] ?? 1,
    );
  }
}