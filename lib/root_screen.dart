
// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:provider/provider.dart';

// import 'package:fresh_farm_app/providers/theme_provider.dart';
// import 'package:fresh_farm_app/screens/cart_screen.dart';
// import 'package:fresh_farm_app/screens/home_screen.dart';
// import 'package:fresh_farm_app/screens/profile_screen.dart';
// import 'package:fresh_farm_app/screens/search_screen.dart';

// class RootScreen extends StatefulWidget {
//   static const routeName = '/root';
//   const RootScreen({super.key});

//   @override
//   State<RootScreen> createState() => _RootScreenState();
// }

// class _RootScreenState extends State<RootScreen> {
//   late List<Widget> screens;
//   int currentScreen = 0;

//   late PageController controller;

//   @override
//   void initState() {
//     screens = const [
//       HomeScreen(),
//       SearchScreen(),
//       CartScreen(),
//       ProfileScreen(),
//     ];
//     controller = PageController(initialPage: currentScreen);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = context.watch<ThemeProvider>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Agri Shop"),
//         actions: [
//           IconButton(
//             icon: Icon(
//               themeProvider.isDarkTheme
//                   ? Icons.nights_stay
//                   : Icons.wb_sunny,
//             ),
//             onPressed: () {
//               context.read<ThemeProvider>().toggleTheme();
//             },
//           ),
//         ],
//       ),

//       body: PageView(
//         physics: const NeverScrollableScrollPhysics(),
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
//         destinations: const [
//           NavigationDestination(
//             selectedIcon: Icon(IconlyBold.activity),
//             icon: Icon(IconlyLight.home),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(IconlyBold.search),
//             icon: Icon(IconlyLight.search),
//             label: 'Search',
//           ),
//           NavigationDestination(
//             selectedIcon: Icon(IconlyBold.bag_2),
//             icon: Icon(IconlyLight.bag_2),
//             label: 'Cart',
//           ),
//           NavigationDestination(
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
// import 'package:provider/provider.dart';

// import 'package:fresh_farm_app/providers/theme_provider.dart';
import 'package:fresh_farm_app/screens/cart_screen.dart';
import 'package:fresh_farm_app/screens/home_screen.dart';
import 'package:fresh_farm_app/screens/profile_screen.dart';
import 'package:fresh_farm_app/screens/search_screen.dart';
import 'package:fresh_farm_app/widgets/customer_drawer.dart'; // Import the drawer

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
    return Scaffold(
      // --- CHANGE 1: Assign the Drawer ---
      drawer: CustomerDrawer(
        onPageChange: (index){
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(index);
        },
      ),
      
      appBar: AppBar(
        title: const Text("Agri Shop"),
        centerTitle: true,
        
        // --- CHANGE 2: Update AppBar Actions ---
        // Removed the Theme Toggle button (it's in the drawer now)
        // Added a leading builder to show the "Menu" icon to open the drawer
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
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
      drawerEnableOpenDragGesture: true, //ensures that swip works
    );
  }
}