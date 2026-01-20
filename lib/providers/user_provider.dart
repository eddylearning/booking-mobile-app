
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/models/user_model.dart';

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
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  bool get isLoggedIn => _user != null;

  String get role => _user?.role ?? 'guest';

  bool get isAdmin => _user?.role == 'admin';
  bool get isRegularUser => _user?.role == 'user';

  // --------------------------------------------------
  // FETCH USER FROM FIRESTORE (USED BY ALL LOGIN METHODS)
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
        // User logged in (email / google) but has no Firestore document yet
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
    } catch (e) {
      debugPrint("Error fetching user: $e");
      rethrow;
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

      // After Firebase login, always fetch Firestore user
      await fetchUser();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  // ==================================================
  // GOOGLE SIGN-IN IS HANDLED HERE 👇
  // ==================================================
  Future<String?> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google account picker
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        return 'Google sign-in cancelled';
      }

      // Step 2: Obtain Google auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create Firebase credential from Google token
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase using Google credentials
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Step 5: Fetch Firestore user (same flow as email login)
      await fetchUser();

      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Google sign-in failed';
    } catch (e) {
      return 'Something went wrong during Google sign-in';
    }
  }

  // ---------------------------------
  // MANUAL USER SETTER (RARELY USED)
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
}
