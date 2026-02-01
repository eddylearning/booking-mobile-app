// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/root_screen.dart';
// import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart';
// import 'package:fresh_farm_app/screens/cart_screen.dart';
// import 'package:fresh_farm_app/screens/order_screen.dart';
// import 'package:fresh_farm_app/screens/profile_screen.dart';
// import 'package:iconly/iconly.dart';
// import 'package:provider/provider.dart';
// import 'package:fresh_farm_app/models/user_model.dart'; // Ensure this path is correct
// import 'package:fresh_farm_app/providers/theme_provider.dart';
// import 'package:fresh_farm_app/providers/user_provider.dart'; // Assuming this provider exposes UserModel
// import 'package:fresh_farm_app/services/my_app_functions.dart';

// class CustomerDrawer extends StatelessWidget {
//   const CustomerDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context);
    
//     // Get the UserModel instance
//     final UserModel? currentUser = userProvider.getUser;

//     return Drawer(
//       child: Material(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         child: ListView(
//           children: [
//             // --- HEADER ---
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               // UPDATED: Using .username from your UserModel
//               accountName: Text(
//                 currentUser?.username ?? "Guest User",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               accountEmail: Text(currentUser?.email ?? ""),
              
//               // UPDATED: Attempting to load userImage, or fallback to initials
//               currentAccountPicture: currentUser?.userImage != null && currentUser!.userImage.isNotEmpty
//                   ? ClipOval(
//                       child: CachedNetworkImage(
//                         imageUrl: currentUser!.userImage,
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
//                         errorWidget: (context, url, error) => const Icon(Icons.error),
//                       ),
//                     )
//                   : CircleAvatar(
//                       backgroundColor: Colors.white70,
//                       child: Text(
//                         currentUser?.username.isNotEmpty == true 
//                             ? currentUser!.username[0].toUpperCase() 
//                             : "G",
//                         style: TextStyle(
//                             color: Theme.of(context).colorScheme.primary, 
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//             ),
            
//             // --- MENU ITEMS ---
            
//             // Home
//             _buildListTile(
//               icon: IconlyBroken.home,
//               title: "Home",
//               onTap: () => Navigator.pushReplacementNamed(context, RootScreen.routeName),
//             ),
            
//             // Cart
//             _buildListTile(
//               icon: IconlyBroken.buy,
//               title: "My Cart",
//               onTap: () => Navigator.pushNamed(context, CartScreen.routeName),
//             ),

//             // Orders
//             _buildListTile(
//               icon: IconlyBroken.paper,
//               title: "My Orders",
//               onTap: () => Navigator.pushNamed(context, OrdersScreen.routeName),
//             ),

//             // Profile
//             _buildListTile(
//               icon: IconlyBroken.profile,
//               title: "Profile",
//               onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
//             ),

//             const Divider(),

//             // ADMIN ONLY SECTION
//             // Checks role from UserModel
//             if (currentUser?.role == "admin")
//               _buildListTile(
//                 icon: Icons.admin_panel_settings,
//                 title: "Admin Dashboard",
//                 color: Colors.purple,
//                 onTap: () => Navigator.pushNamed(context, AdminDashboard.routeName),
//               ),

//             // Theme Toggle
//             SwitchListTile(
//               secondary: Icon(
//                 themeProvider.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
//               ),
//               title: const Text("Dark Mode"),
//               value: themeProvider.isDarkTheme,
//               onChanged: (value) {
//                 themeProvider.toggleTheme();
//               },
//             ),

//             // Logout
//             _buildListTile(
//               icon: IconlyBroken.logout,
//               title: "Logout",
//               color: Colors.red,
//               onTap: () async {
//                 await MyAppFunctions.showErrorOrWarningDialog(
//                   context: context,
//                   subtitle: "Are you sure you want to logout?",
//                   fct: () async {
//                     // Add actual logout logic here (e.g., AppManager.instance.logout())
//                     Navigator.of(context).pop(); 
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildListTile({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(title),
//       onTap: onTap,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fresh_farm_app/screens/order_screen.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/models/user_model.dart';
import 'package:fresh_farm_app/providers/theme_provider.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
// import 'package:fresh_farm_app/screens/customer/orders_screen.dart';
import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart';
// import 'package:fresh_farm_app/root_screen.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

class CustomerDrawer extends StatelessWidget {
  const CustomerDrawer({super.key, required this.onPageChange});

  // --- NEW: Callback to change RootScreen Tabs ---
  final Function(int) onPageChange;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final UserModel? currentUser = userProvider.getUser;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          // Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            accountName: TitlesTextWidget(
              label: currentUser?.username ?? "Guest User",
              color: Colors.white,
              fontSize: 18,
            ),
            accountEmail: Text(
              currentUser?.email ?? "",
              style: const TextStyle(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                currentUser?.username.isNotEmpty == true
                    ? currentUser!.username[0].toUpperCase()
                    : "G",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Home (Tab 0)
          _buildListTile(
            context: context,
            icon: IconlyBroken.home,
            title: "Home",
            onTap: () {
              Navigator.pop(context); // Close drawer
              onPageChange(0); // Switch to Home Tab
            },
          ),

          // Cart (Tab 2) - FIXED: Use Tab Switch instead of Push
          _buildListTile(
            context: context,
            icon: IconlyBroken.buy,
            title: "My Cart",
            onTap: () {
              Navigator.pop(context);
              onPageChange(2); // Switch to Cart Tab
            },
          ),

          // Orders (NOT a tab) - Use PushNamed
          _buildListTile(
            context: context,
            icon: IconlyBroken.paper,
            title: "My Orders",
            onTap: () {
              Navigator.pushNamed(context, OrdersScreen.routeName);
            },
          ),

          // Profile (Tab 3) - FIXED: Use Tab Switch instead of Push
          _buildListTile(
            context: context,
            icon: IconlyBroken.profile,
            title: "My Profile",
            onTap: () {
              Navigator.pop(context);
              onPageChange(3); // Switch to Profile Tab
            },
          ),

          const Divider(),

          // Admin
          if (currentUser?.role == "admin")
            _buildListTile(
              context: context,
              icon: Icons.admin_panel_settings,
              title: "Admin Dashboard",
              color: Colors.purple,
              onTap: () {
                Navigator.pushNamed(context, AdminDashboard.routeName);
              },
            ),

          // Theme Toggle
          SwitchListTile(
            secondary: Icon(
              themeProvider.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
              color: Theme.of(context).iconTheme.color,
            ),
            title: TitlesTextWidget(label: "Dark Mode", fontSize: 16),
            value: themeProvider.isDarkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),

          // Logout
          _buildListTile(
            context: context,
            icon: IconlyBroken.logout,
            title: "Logout",
            color: Colors.red,
            onTap: () async {
              userProvider.clearUser();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      onTap: onTap,
    );
  }
}