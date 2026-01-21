// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/constants/theme_data.dart';
// import 'package:flutter_application_1/firebase_options.dart';
// import 'package:flutter_application_1/providers/theme_provider.dart';
// import 'package:flutter_application_1/providers/user_provider.dart';
// import 'package:flutter_application_1/root_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyCrudApp());
// }

// class MyCrudApp extends StatelessWidget {
//   const MyCrudApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//       ],
//       child: Consumer<ThemeProvider>(
//         builder: (context, themeProvider, child) {
//           return MaterialApp(
//             title: 'Firebase Crud',
//             theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme),
//             home: const RootScreen(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/theme_data.dart';
import 'package:flutter_application_1/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/theme_provider.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
// import 'package:flutter_application_1/theme/theme_styles.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
// import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter_application_1/screens/forgot_password_screen.dart';
// import 'package:flutter_application_1/screens/home_screen.dart';
// import 'package:flutter_application_1/root_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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

    // Fetch user data on app start
    userProvider.fetchUser();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeStyles.lightTheme,
      darkTheme: ThemeStyles.darkTheme,
      themeMode: themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,

      initialRoute: userProvider.isLoggedIn ?  RootScreen.routeName :  LoginScreen.routName,

      routes:{
        LoginScreen.routName: (Context) => LoginScreen(),
        RegisterScreen.routeName: (Context) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
        RootScreen.routeName: (context) => const RootScreen(),
      } ,
    );
  }
}


