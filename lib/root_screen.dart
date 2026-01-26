// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';

// import 'package:flutter_application_1/screens/cart_screen.dart';
// import 'package:flutter_application_1/screens/home_screen.dart';
// import 'package:flutter_application_1/screens/profile_screen.dart';
// import 'package:flutter_application_1/screens/search_screen.dart';

// class RootScreen extends StatefulWidget {
//   static const routeName = '/root';
//   const RootScreen({super.key});

//   @override
//   State<RootScreen> createState() => _RootScreenState();
// }

// class _RootScreenState extends State<RootScreen> {
//     late List<Widget>screens;
//     int currentScreen =0;

//     late PageController controller;

//     @override
//     void initState(){

//       screens = const[
//         HomeScreen(),
//         SearchScreen(),
//         CartScreen(),
//         ProfileScreen(),
//       ];
//        controller = PageController(initialPage: currentScreen);
//     super.initState();

//     }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         physics: NeverScrollableScrollPhysics(),
//         controller: controller,
//         children: screens,
//       ),

//       bottomNavigationBar: NavigationBar(
//         selectedIndex: currentScreen,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,

//         height: kBottomNavigationBarHeight,
//         onDestinationSelected: (index) {
//           setState(() {
//             currentScreen = index;
//           });

//           controller.jumpToPage(currentScreen);
//         },

//         destinations: [
//           NavigationDestination(
//             selectedIcon: Icon(IconlyBold.activity),
//             icon: Icon(IconlyLight.home),
//             label: 'Home',
//           ),
//             NavigationDestination(
//             selectedIcon: Icon(IconlyBold.search),
//             icon: Icon(IconlyLight.search),
//             label: 'Search',
//           ),
//             NavigationDestination(
//             selectedIcon: Icon(IconlyBold.bag_2),
//             icon: Icon(IconlyLight.bag_2),
//             label: 'Cart',
//           ),

//             NavigationDestination(
//             selectedIcon: Icon(IconlyBold.profile),
//             icon: Icon(IconlyLight.profile),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import 'package:fresh_farm_app/providers/theme_provider.dart';
import 'package:fresh_farm_app/screens/cart_screen.dart';
import 'package:fresh_farm_app/screens/home_screen.dart';
import 'package:fresh_farm_app/screens/profile_screen.dart';
import 'package:fresh_farm_app/screens/search_screen.dart';

class RootScreen extends StatefulWidget {
  static const routeName = '/root';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;

  late PageController controller;

  @override
  void initState() {
    screens = const [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agri Shop"),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkTheme
                  ? Icons.nights_stay
                  : Icons.wb_sunny,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),

      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        height: kBottomNavigationBarHeight,
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.activity),
            icon: Icon(IconlyLight.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.search),
            icon: Icon(IconlyLight.search),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.bag_2),
            icon: Icon(IconlyLight.bag_2),
            label: 'Cart',
          ),
          NavigationDestination(
            selectedIcon: Icon(IconlyBold.profile),
            icon: Icon(IconlyLight.profile),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
