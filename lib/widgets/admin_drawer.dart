// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:provider/provider.dart';
// import 'package:fresh_farm_app/models/user_model.dart';
// import 'package:fresh_farm_app/providers/theme_provider.dart';
// import 'package:fresh_farm_app/providers/user_provider.dart';
// import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart';
// import 'package:fresh_farm_app/screens/admin/manage_products_screen.dart'; // Ensure you create this
// import 'package:fresh_farm_app/screens/admin/add_product_screen.dart';     // Ensure you create this
// import 'package:fresh_farm_app/screens/admin/admin_orders_screen.dart';   // Ensure you create this
// import 'package:fresh_farm_app/widgets/title_text.dart';

// class AdminDrawer extends StatelessWidget {
//   const AdminDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final userProvider = Provider.of<UserProvider>(context);
//     final UserModel? currentUser = userProvider.getUser;

//     return Drawer(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       child: ListView(
//         children: [
//           // --- HEADER ---
//           UserAccountsDrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             accountName: TitlesTextWidget(
//               label: currentUser?.username ?? "Admin User",
//               color: Colors.white,
//               fontSize: 18,
//             ),
//             accountEmail: Text(
//               currentUser?.email ?? "",
//               style: const TextStyle(color: Colors.white70),
//             ),
//             currentAccountPicture: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(
//                 currentUser?.username.isNotEmpty == true
//                     ? currentUser!.username[0].toUpperCase()
//                     : "A",
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),

//           // --- DASHBOARD ---
//           _buildListTile(
//             context: context,
//             icon: Icons.dashboard,
//             title: "Dashboard",
//             onTap: () {
//               Navigator.pushReplacementNamed(context, AdminDashboard.routeName);
//             },
//           ),

//           const Divider(),

//           // --- PRODUCTS MANAGEMENT ---
//           _buildListTile(
//             context: context,
//             icon: Icons.inventory_2_outlined,
//             title: "Manage Products",
//             onTap: () {
//               Navigator.pushNamed(context, ManageProductsScreen.routeName);
//             },
//           ),

//           _buildListTile(
//             context: context,
//             icon: Icons.add_circle_outline,
//             title: "Add New Product",
//             onTap: () {
//               Navigator.pushNamed(context, AddProductScreen.routeName);
//             },
//           ),

//           // --- ORDERS MANAGEMENT ---
//           _buildListTile(
//             context: context,
//             icon: IconlyBroken.paper,
//             title: "View All Orders",
//             onTap: () {
//               Navigator.pushNamed(context, AdminOrdersScreen.routeName);
//             },
//           ),
          
//           // --- REPORTS (Optional) ---
//           _buildListTile(
//             context: context,
//             icon: Icons.bar_chart,
//             title: "Sales Reports",
//             onTap: () {
//               // Navigate to Reports Screen when created
//               // Navigator.pushNamed(context, AdminReportsScreen.routeName);
//             },
//           ),

//           const Divider(),

//           // --- SETTINGS ---
//           SwitchListTile(
//             secondary: Icon(
//               themeProvider.isDarkTheme ? Icons.dark_mode : Icons.light_mode,
//               color: Theme.of(context).iconTheme.color,
//             ),
//             title: TitlesTextWidget(label: "Dark Mode", fontSize: 16),
//             value: themeProvider.isDarkTheme,
//             onChanged: (value) {
//               themeProvider.toggleTheme();
//             },
//           ),

//           _buildListTile(
//             context: context,
//             icon: IconlyBroken.logout,
//             title: "Logout",
//             color: Colors.red,
//             onTap: () async {
//               // Show confirmation dialog
//               final confirm = await showDialog<bool>(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: const Text("Logout"),
//                   content: const Text("Are you sure you want to logout?"),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, false),
//                       child: const Text("Cancel"),
//                     ),
//                     TextButton(
//                       onPressed: () => Navigator.pop(context, true),
//                       child: const Text("Yes"),
//                     ),
//                   ],
//                 ),
//               );

//               if (confirm == true) {
//                 userProvider.clearUser();
//                 if (context.mounted) {
//                   Navigator.pushReplacementNamed(context, '/login');
//                 }
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(
//         title,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Theme.of(context).textTheme.bodyLarge?.color,
//         ),
//       ),
//       onTap: onTap,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fresh_farm_app/screens/admin/admin_reports_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/models/user_model.dart';
import 'package:fresh_farm_app/providers/theme_provider.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
// import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart';
// import 'package:fresh_farm_app/screens/admin/manage_products_screen.dart';
import 'package:fresh_farm_app/screens/admin/add_product_screen.dart';
// import 'package:fresh_farm_app/screens/admin/admin_orders_screen.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key, required this.onPageChange});

  // Callback to switch views in AdminRootScreen
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
              label: currentUser?.username ?? "Admin User",
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
                    : "A",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // DASHBOARD (Tab 0)
          _buildListTile(
            context: context,
            icon: Icons.dashboard,
            title: "Dashboard",
            onTap: () {
              Navigator.pop(context);
              onPageChange(0); // Switch to Dashboard
            },
          ),

          const Divider(),

          // MANAGE PRODUCTS (Tab 1)
          _buildListTile(
            context: context,
            icon: Icons.inventory_2_outlined,
            title: "Manage Products",
            onTap: () {
              Navigator.pop(context);
              onPageChange(1); // Switch to Manage Products
            },
          ),

          // VIEW ORDERS (Tab 2)
          _buildListTile(
            context: context,
            icon: IconlyBroken.paper,
            title: "View All Orders",
            onTap: () {
              Navigator.pop(context);
              onPageChange(2); // Switch to Orders
            },
          ),
          
          // ADD PRODUCT (Push instead of Switch)
          _buildListTile(
            context: context,
            icon: Icons.add_circle_outline,
            title: "Add New Product",
            onTap: () {
              Navigator.pushNamed(context, AddProductScreen.routeName);
            },
          ),
          
          // REPORTS (Push instead of Switch)
          _buildListTile(
            context: context,
            icon: Icons.bar_chart,
            title: "Sales Reports",
            onTap: () {
              // Navigate to Reports Screen when created
               Navigator.pushNamed(context, AdminReportsScreen.routeName);
            },
          ),

          const Divider(),

          // --- SETTINGS ---
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

          _buildListTile(
            context: context,
            icon: IconlyBroken.logout,
            title: "Logout",
            color: Colors.red,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                // userProvider.clearUser(); // Or use your logout logic
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
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