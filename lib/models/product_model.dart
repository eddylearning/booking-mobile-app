// //remeber to change data to organic products


// class Students {
//   final String docId;
//   final String name;
//   final String age;
//   final String dob;

//   Students({
//     required this.docId,
//     required this.name,
//     required this.age,
//     required this.dob,
//   });

//   factory Students.fromJson(String docId, Map<String, dynamic> json) {
//     return Students(
//       docId: docId,
//       name: json['name'] ?? '',
//       age: json['age'] ?? '',
//       dob: json['dob'] ?? '',
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final int stock;
  final Timestamp createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.stock,
    required this.createdAt,
  });

  // Create from Firestore Document
  factory ProductModel.fromDocument(String id, Map<String, dynamic> doc) {
    return ProductModel(
      id: id,
      name: doc['name'] ?? '',
      category: doc['category'] ?? 'General',
      price: (doc['price'] is num) ? (doc['price'] as num).toDouble() : 0.0,
      description: doc['description'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      stock: doc['stock'] ?? 0,
      createdAt: doc['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'stock': stock,
      'createdAt': createdAt,
    };
  }
}