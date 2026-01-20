// class User {
//   User({
//     required this.name,
//     required this.age,
//     required this.dob,
//     required this.docId,
//   });

//   String age;

//   String name;

//   String dob;

//   String docId;

//   factory User.fromJson(String id, Map<String, dynamic> json) {
//     return User(
//       name: json['name'],
//       age: json['age'],
//       dob: json['dob'],
//       docId: id,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String userImage;
  final Timestamp createdAt;
  final List userCart;
  final List userWish;
  final String role;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.userImage,
    required this.createdAt,
    required this.userCart,
    required this.userWish,
    required this.role,
  });

  factory UserModel.fromDocument(String uid, Map<String, dynamic> doc) {
    return UserModel(
      uid: uid,
      username: doc['username'] ?? '',
      email: doc['email'] ?? '',
      role: doc['role'] ?? 'user',
      userImage: doc['userImage'] ?? '',
      createdAt: doc['createdAt'] ?? Timestamp.now(),
      userCart: List.from(doc['userCart'] ?? []),
      userWish: List.from(doc['userWish'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'userImage': userImage,
      'createdAt': createdAt,
      'userCart': userCart,
      'userWish': userWish,
      'role': role,
    };
  }
}