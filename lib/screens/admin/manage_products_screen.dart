import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_farm_app/services/database_service.dart';
import 'package:fresh_farm_app/screens/admin/add_product_screen.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage_products';
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TitlesTextWidget(label: "Manage Products")),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.fetchProductsForAdmin().asStream(), // Helper needed or use simple snapshot
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Error loading"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(child: SubtitleTextWidget(label: "No products found"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final data = product.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['imageUrl'] ?? ''),
                  ),
                  title: TitlesTextWidget(label: data['name']),
                  subtitle: SubtitleTextWidget(label: "KES ${data['price']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Pass product data to Edit screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductScreen(productData: data, productId: product.id),
                            ),
                          );
                        },
                      ),
                      // Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // Confirmation dialog
                          final confirm = await _confirmDelete(context, data['name']);
                          if (confirm == true) {
                            DatabaseService.instance.deleteProduct(product.id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: Text("Are you sure you want to delete $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}