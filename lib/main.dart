
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/constants/theme_data.dart';
// import 'package:fresh_farm_app/firebase_options.dart';
// import 'package:fresh_farm_app/root_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:fresh_farm_app/providers/theme_provider.dart';
// import 'package:fresh_farm_app/providers/user_provider.dart';
// // import 'package:fresh_farm_app/theme/theme_styles.dart';
// // import 'package:fresh_farm_app/screens/home_screen.dart';
// import 'package:fresh_farm_app/screens/auth/login_screen.dart';
// // import 'package:fresh_farm_app/screens/login_screen.dart';
// import 'package:fresh_farm_app/screens/auth/signup_screen.dart';
// import 'package:fresh_farm_app/screens/auth/forgot_password_screen.dart';
// // import 'package:fresh_farm_app/screens/home_screen.dart';
// // import 'package:fresh_farm_app/root_screen.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context, listen: false);

//     // Fetch user data on app start
//     userProvider.fetchUser();

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeStyles.lightTheme,
//       darkTheme: ThemeStyles.darkTheme,
//       themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

//       initialRoute: userProvider.isLoggedIn ?  RootScreen.routeName :  LoginScreen.routName,

//       routes:{
//         LoginScreen.routName: (Context) => LoginScreen(),
//         RegisterScreen.routeName: (Context) => const RegisterScreen(),
//         ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
//         RootScreen.routeName: (context) => const RootScreen(),
//       } ,
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm_app/constants/theme_data.dart';
import 'package:fresh_farm_app/firebase_options.dart';
import 'package:fresh_farm_app/providers/cart_provider.dart';
import 'package:fresh_farm_app/providers/product_provider.dart';
import 'package:fresh_farm_app/root_screen.dart';
import 'package:fresh_farm_app/screens/order_screen.dart';
import 'package:fresh_farm_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/providers/theme_provider.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';

// --- Screen Imports ---
import 'package:fresh_farm_app/screens/auth/login_screen.dart';
import 'package:fresh_farm_app/screens/auth/signup_screen.dart';
import 'package:fresh_farm_app/screens/auth/forgot_password_screen.dart';
// --- CHANGE 3: Import Admin Dashboard ---
import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart'; 
// Also importing CartScreen/OrdersScreen if you want to navigate there via Drawer directly
import 'package:fresh_farm_app/screens/cart_screen.dart'; 

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
    ChangeNotifierProvider(create: (_) => ProductProvider()), // Add this line
  ],
  child: const MyApp(),
),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Fetch user data on app start (Ideally, do this in a Splash Screen)
    userProvider.fetchUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fresh Farm App',
      theme: ThemeStyles.lightTheme,
      darkTheme: ThemeStyles.darkTheme,
      themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

      // Initial Route Logic
      initialRoute: userProvider.isLoggedIn ? RootScreen.routeName : LoginScreen.routeName,

      routes: {
        // Auth Routes
        LoginScreen.routeName: (ctx) => LoginScreen(),
        RegisterScreen.routeName: (ctx) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
        
        // Main App Routes
        RootScreen.routeName: (ctx) => const RootScreen(),
        
        // --- CHANGE 3: Added Admin Dashboard Route ---
        AdminDashboard.routeName: (ctx) => const AdminDashboard(),
        CartScreen.routeName: (ctx) => const CartScreen(), // Added for Drawer navigation
        // Add other routes (OrdersScreen, ProfileScreen) if needed
         OrdersScreen.routeName: (ctx) => const OrdersScreen(),
        ProfileScreen.routeName: (ctx) => const ProfileScreen(),
      },
    );
  }
}