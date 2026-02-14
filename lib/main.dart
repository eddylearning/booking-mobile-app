// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/admin_root_screen.dart';
// import 'package:fresh_farm_app/constants/theme_data.dart';
// import 'package:fresh_farm_app/firebase_options.dart';
// import 'package:fresh_farm_app/providers/cart_provider.dart';
// import 'package:fresh_farm_app/providers/product_provider.dart';
// import 'package:fresh_farm_app/root_screen.dart';
// import 'package:fresh_farm_app/screens/admin/add_product_screen.dart';
// import 'package:fresh_farm_app/screens/admin/admin_orders_screen.dart';
// import 'package:fresh_farm_app/screens/admin/admin_reports_screen.dart';
// import 'package:fresh_farm_app/screens/admin/manage_products_screen.dart';
// import 'package:fresh_farm_app/screens/checkout_screen.dart';
// import 'package:fresh_farm_app/screens/edit_profile_screen.dart';
// import 'package:fresh_farm_app/screens/help_screen.dart';
// import 'package:fresh_farm_app/screens/order_screen.dart';
// import 'package:fresh_farm_app/screens/product_details_screen.dart';
// import 'package:fresh_farm_app/screens/profile_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:fresh_farm_app/providers/theme_provider.dart';
// import 'package:fresh_farm_app/providers/user_provider.dart';

// // --- Screen Imports ---
// import 'package:fresh_farm_app/screens/auth/login_screen.dart';
// import 'package:fresh_farm_app/screens/auth/signup_screen.dart';
// import 'package:fresh_farm_app/screens/auth/forgot_password_screen.dart';
// // --- CHANGE 3: Import Admin Dashboard ---
// // import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart'; 
// // Also importing CartScreen/OrdersScreen if you want to navigate there via Drawer directly
// import 'package:fresh_farm_app/screens/cart_screen.dart'; 

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(
//     MultiProvider(
//   providers: [
//     ChangeNotifierProvider(create: (_) => ThemeProvider()),
//     ChangeNotifierProvider(create: (_) => UserProvider()),
//     ChangeNotifierProvider(create: (_) => CartProvider()),
//     ChangeNotifierProvider(create: (_) => ProductProvider()), // Add this line
//   ],
//   child: const MyApp(),
// ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     // Fetch user data on app start (Ideally, do this in a Splash Screen)
//     userProvider.fetchUser(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Fresh Farm App',
//       theme: ThemeStyles.lightTheme,
//       darkTheme: ThemeStyles.darkTheme,
//       themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

//       // Initial Route Logic
//       initialRoute: userProvider.isLoggedIn ? RootScreen.routeName : LoginScreen.routeName,

//       routes: {
//         // Auth Routes
//         LoginScreen.routeName: (ctx) => LoginScreen(),
//         RegisterScreen.routeName: (ctx) => const RegisterScreen(),
//         ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
        
//         // Main App Routes
//         RootScreen.routeName: (ctx) => const RootScreen(),
        
//         // --- CHANGE 3: Added Admin Dashboard  and other Routes ---
//         // AdminDashboard.routeName: (ctx) => const AdminDashboard(),
//         AdminRootScreen.routeName:(ctx) => const AdminRootScreen(),
//         ManageProductsScreen.routeName:(ctx) => ManageProductsScreen(),
//         AddProductScreen.routeName:(ctx) => AddProductScreen(),
//         AdminOrdersScreen.routeName:(ctx) => AdminOrdersScreen(),
//         AdminReportsScreen.routeName:(ctx) => AdminReportsScreen(),
//         CartScreen.routeName: (ctx) => const CartScreen(), // Added for Drawer navigation
//         // Add other routes (OrdersScreen, ProfileScreen) if needed
//          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
//         ProfileScreen.routeName: (ctx) => const ProfileScreen(),
//         HelpScreen.routeName: (ctx) => const HelpScreen(),
//         CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
//         EditProfileScreen.routeName:(ctx) => const EditProfileScreen(),
//         ProductDetailsScreen.routeName:(ctx) => const ProductDetailsScreen(),
//       },
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm_app/admin_root_screen.dart';
// import 'package:fresh_farm_app/screens/admin/admin_root_screen.dart'; // Fixed path
import 'package:fresh_farm_app/constants/theme_data.dart';
import 'package:fresh_farm_app/firebase_options.dart';
import 'package:fresh_farm_app/providers/cart_provider.dart';
import 'package:fresh_farm_app/providers/product_provider.dart';
import 'package:fresh_farm_app/root_screen.dart';
import 'package:fresh_farm_app/screens/admin/add_product_screen.dart';
import 'package:fresh_farm_app/screens/admin/admin_orders_screen.dart';
import 'package:fresh_farm_app/screens/admin/admin_reports_screen.dart';
import 'package:fresh_farm_app/screens/admin/manage_products_screen.dart';

// --- Customer Screen Imports (Fixed paths) ---
import 'package:fresh_farm_app/screens/checkout_screen.dart';
import 'package:fresh_farm_app/screens/help_screen.dart';
import 'package:fresh_farm_app/screens/order_screen.dart';
// import 'package:fresh_farm_app/screens/orders_screen.dart'; // Assuming this is the filename
import 'package:fresh_farm_app/screens/product_details_screen.dart';

// --- Other Screen Imports ---
import 'package:fresh_farm_app/screens/edit_profile_screen.dart';
import 'package:fresh_farm_app/screens/profile_screen.dart';
import 'package:fresh_farm_app/screens/cart_screen.dart';

import 'package:provider/provider.dart';
import 'package:fresh_farm_app/providers/theme_provider.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';

// --- Auth Imports ---
import 'package:fresh_farm_app/screens/auth/login_screen.dart';
import 'package:fresh_farm_app/screens/auth/signup_screen.dart';
import 'package:fresh_farm_app/screens/auth/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // --- HELPER FOR INITIAL ROUTE LOGIC ---
  String _getInitialRoute(UserProvider userProvider) {
    if (!userProvider.isLoggedIn) {
      return LoginScreen.routeName;
    }

    // Check Role
    if (userProvider.role == 'admin') {
      return AdminRootScreen.routeName;
    }
    
    // Default to Customer
    return RootScreen.routeName;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // WARNING: Do NOT call fetchUser(context) here. 
    // It causes infinite loops. UserProvider should listen to Auth changes internally.

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fresh Farm App',
      theme: ThemeStyles.lightTheme,
      darkTheme: ThemeStyles.darkTheme,
      themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

      // --- FIXED INITIAL ROUTE LOGIC ---
      initialRoute: _getInitialRoute(userProvider),

      routes: {
        // Auth Routes
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
        
        // Main App Routes
        RootScreen.routeName: (ctx) => const RootScreen(),
        
        // Admin Routes
        AdminRootScreen.routeName: (ctx) => const AdminRootScreen(),
        ManageProductsScreen.routeName: (ctx) => const ManageProductsScreen(),
        AddProductScreen.routeName: (ctx) => const AddProductScreen(),
        AdminOrdersScreen.routeName: (ctx) => const AdminOrdersScreen(),
        AdminReportsScreen.routeName: (ctx) => const AdminReportsScreen(),
        
        // Customer/Shared Routes
        CartScreen.routeName: (ctx) => const CartScreen(),
        OrdersScreen.routeName: (ctx) => const OrdersScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
        HelpScreen.routeName: (ctx) => const HelpScreen(),
        CheckoutScreen.routeName: (ctx) => const CheckoutScreen(),
        EditProfileScreen.routeName: (ctx) => const EditProfileScreen(),
        ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
      },
    );
  }
}