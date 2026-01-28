import 'package:flutter/material.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';

class AdminDashboard extends StatelessWidget {
  static const routeName = '/admin_dashboard';
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TitlesTextWidget(
              label: "Admin Panel",
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.1,
            children: [
              _buildAdminCard(
                title: "Manage Products",
                icon: Icons.shopping_basket,
                color: Colors.green,
                onTap: () {
                  // TODO: Navigate
                },
              ),
              _buildAdminCard(
                title: "View Orders",
                icon: Icons.list_alt,
                color: Colors.blue,
                onTap: () {
                  // TODO: Navigate
                },
              ),
              _buildAdminCard(
                title: "Add Product",
                icon: Icons.add_circle_outline,
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate
                },
              ),
              _buildAdminCard(
                title: "Users",
                icon: Icons.people,
                color: Colors.purple,
                onTap: () {
                  // TODO: Navigate
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TitlesTextWidget(
                label: title,
                fontSize: 14,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}