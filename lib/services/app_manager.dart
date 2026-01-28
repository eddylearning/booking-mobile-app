// class AssetsManager {
//   static String imagesPath = "assets/images";
//   static String profileImagesPath = "assets/images/profile";
//   static String bagImagesPath = "assets/images/bag";
//   static String bannersImagesPath = "assets/images/banners";
//   static String categoriesImagesPath = "assets/images/categories";
//     static String dashboardImagesPath = "assets/images/dashboard";

//   // general images
//   static String forgotPassword = "$imagesPath/forgot_password.jpg";
//   static String mapRounded = "$imagesPath/rounded_map.png";
//   static String warning = "$imagesPath/warning.png";
//   static String error = "$imagesPath/error.png";
//   static String addressMap = "$imagesPath/address_map.png";
//   static String emptySearch = "$imagesPath/empty_search.png";

//   static String successful = "$imagesPath/successful.png";

//   // Profile
//   static String address = "$profileImagesPath/address.png";
//   static String login = "$profileImagesPath/login.png";
//   static String logout = "$profileImagesPath/logout.png";
//   static String privacy = "$profileImagesPath/privacy.png";
//   static String recent = "$profileImagesPath/recent.png";
//   static String theme = "$profileImagesPath/theme.png";
//   // Bag
//   static String bagWish = "$bagImagesPath/bag_wish.png";
//   static String shoppingBasket = "$bagImagesPath/shopping_basket.png";
//   static String shoppingCart = "$bagImagesPath/shopping_cart.png";
//   static String orderBag = "$bagImagesPath/order.png";
//   static String orderSvg = "$bagImagesPath/order_svg.png";
//   static String wishlistSvg = "$bagImagesPath/wishlist_svg.png";
//   // Banners
//   static String banner1 = "$bannersImagesPath/banner1.png";
//   static String banner2 = "$bannersImagesPath/banner2.png";
//   static String banner3 = "$bannersImagesPath/banner3.jpg";
//     static String banner4 = "$bannersImagesPath/banner4.jpg";
//   // Categories path
//   static String mobiles = "$categoriesImagesPath/mobiles.png";
//   static String fashion = "$categoriesImagesPath/fashion.png";
//   static String watch = "$categoriesImagesPath/watch.png";
//   static String book = "$categoriesImagesPath/book_img.png";
//   static String electronics = "$categoriesImagesPath/electronics.png";
//   static String cosmetics = "$categoriesImagesPath/cosmetics.png";
//   static String shoes = "$categoriesImagesPath/shoes.png";
//   static String pc = "$categoriesImagesPath/pc.png";

//   //dashboard 
//   static String order = "$dashboardImagesPath/order.png";
//   static String cloud = "$dashboardImagesPath/cloud.png";

// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fresh_farm_app/root_screen.dart';
import 'package:fresh_farm_app/screens/auth/login_screen.dart';

/// Handles high-level application logic, such as initialization
/// and determining the initial route for the user.
class AppManager {
  // Singleton pattern
  static final AppManager instance = AppManager._internal();
  AppManager._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Determines the initial screen based on the current user's authentication state.
  /// Call this in your main.dart or a splash screen to route the user.
  Future<String> getInitialRoute() async {
    try {
      // Wait briefly for Auth to initialize from local storage
      // In a real production app, you might listen to authStateChanges,
      // but for initial route determination, a simple check is often sufficient.
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        if (kDebugMode) {
          print("User is logged in: ${currentUser.email}");
        }
        // Navigate to the root screen (which contains the drawer and sub-routes)
        return RootScreen.routeName;
      } else {
        if (kDebugMode) {
          print("No user logged in.");
        }
        // Navigate to Login
        return LoginScreen.routName;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error determining initial route: $e");
      }
      // Fallback to Login if anything goes wrong
      return LoginScreen.routName;
    }
  }

  /// Logout helper
  Future<void> logout() async {
    await _auth.signOut();
  }
}