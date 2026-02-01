
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/models/user_model.dart';

// class UserProvider with ChangeNotifier {
//   UserModel? _user;

//   UserModel? get getUser {
//     return _user;
//   }

//   bool get isLoggedIn {
//     return _user != null;
//   }

//   String get role {
//     return _user?.role ?? 'guest';
//   }



//   Future<void> fetchUser() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser == null) {
//       _user = null;
//       notifyListeners();
//       return;
//     }

//     try {
//       final docSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser.uid)
//           .get();

//       if (docSnapshot.exists && docSnapshot.data() != null) {
//         _user = UserModel.fromDocument(
//           currentUser.uid,
//           docSnapshot.data() as Map<String, dynamic>,
//         );
//       } else {
//         _user = UserModel(
//           uid: currentUser.uid,
//           username: currentUser.displayName ?? '',
//           email: currentUser.email ?? '',
//           role: 'user', userCart: [], userWish: [], userImage: '', createdAt: Timestamp.now(),
//         );
//       }
//       notifyListeners();
//     } catch (e) {
//       debugPrint("Error fetching user: $e");
//       rethrow;
//     }
//   }


//   Future<String?> login(String email, String password) async {
//   try {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     // fetch Firestore user after login
//     await fetchUser(); 
//     return null; 
//   } on FirebaseAuthException catch (e) {
//     return e.message ?? "Login failed";
//   } catch (e) {
//     return e.toString();
//   }
// }
// void setUser(UserModel user) {
//   _user = user;
//   notifyListeners();
// }


//   void clearUser() {
//     _user = null;
//     notifyListeners();
//   }




//   bool get isAdmin => _user?.role == 'admin';
//   bool get isRegularUser => _user?.role == 'user';
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm_app/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;
  bool get isLoggedIn => _user != null;
  String get role => _user?.role ?? 'guest';

  bool get isAdmin => _user?.role == 'admin';
  bool get isRegularUser => _user?.role == 'user';

  // --------------------------------------------------
  // FETCH USER FROM FIRESTORE (WEB SAFE)
  // --------------------------------------------------
  Future<void> fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _user = null;
      notifyListeners();
      return;
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        _user = UserModel.fromDocument(
          currentUser.uid,
          docSnapshot.data() as Map<String, dynamic>,
        );
      } else {
        // Auth user exists but Firestore doc not yet created
        _user = UserModel(
          uid: currentUser.uid,
          username: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          role: 'user',
          userCart: [],
          userWish: [],
          userImage: '',
          createdAt: Timestamp.now(),
        );
      }

      notifyListeners();
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('Firebase error fetching user: ${e.message}');
      debugPrintStack(stackTrace: stackTrace);

      // Fail gracefully (critical for Flutter Web)
      _user = null;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Unknown error fetching user: $e');
      debugPrintStack(stackTrace: stackTrace);

      _user = null;
      notifyListeners();
    }
  }

  // ---------------------------------
  // EMAIL & PASSWORD LOGIN
  // ---------------------------------
  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await fetchUser();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    } catch (e) {
      return e.toString();
    }
  }

  // ---------------------------------
  // GOOGLE SIGN-IN
  // ---------------------------------
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        return 'Google sign-in cancelled';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await fetchUser();

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Google sign-in failed';
    } catch (_) {
      return 'Something went wrong during Google sign-in';
    }
  }

  // ---------------------------------
  // MANUAL USER SETTER
  // ---------------------------------
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // ---------------------------------
  // LOGOUT / CLEAR USER
  // ---------------------------------
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> updateProfile(
    {required String username,
     required String imageUrl})async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // 1. Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'username': username,
        'userImage': imageUrl,
      });

      // 2. Refresh local state
      await fetchUser();
      
      if (kDebugMode) {
        print("Profile updated successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating profile: $e");
      }
      rethrow;
    }
  }
}

