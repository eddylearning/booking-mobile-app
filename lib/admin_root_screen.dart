import 'package:flutter/material.dart';
import 'package:fresh_farm_app/screens/admin/admin_dashboard.dart';
import 'package:fresh_farm_app/screens/admin/manage_products_screen.dart';
import 'package:fresh_farm_app/screens/admin/admin_orders_screen.dart';
import 'package:fresh_farm_app/widgets/admin_drawer.dart';

class AdminRootScreen extends StatefulWidget {
  static const routeName = '/admin_root';
  const AdminRootScreen({super.key});

  @override
  State<AdminRootScreen> createState() => _AdminRootScreenState();
}

class _AdminRootScreenState extends State<AdminRootScreen> {
  late PageController controller;
  int currentScreen = 0;

  //helper for titles
  final List<String> _title =[
    "Admin Dashboard",
    "Manage Products",
    "view All Orders"
  ];

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // THE DRAWER
      drawer: AdminDrawer(
        onPageChange: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(index);
        },
      ),
      
      // APP BAR
      appBar: AppBar(
        title: Text(_title[currentScreen]),
        centerTitle: true,
        // The hamburger icon is automatic when 'drawer' is defined
      ),
      
      // BODY
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // Prevent swiping between pages
        controller: controller,
        children: const [
          AdminDashboard(),      // Index 0
          ManageProductsScreen(), // Index 1
          AdminOrdersScreen(),    // Index 2
        ],
      ),
    );
  }
}