// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fresh_farm_app/services/database_service.dart';

// class ManageProductsScreen extends StatelessWidget {
//   static const routeName = '/manage_products';
//   const ManageProductsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Products'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: DatabaseService.instance.fetchProductsForAdmin(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return const Center(child: Text('Failed to load products'));
//           }

//           final docs = snapshot.data?.docs ?? [];

//           if (docs.isEmpty) {
//             return const Center(child: Text('No products found'));
//           }

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 child: ListTile(
//                   title: Text(data['name'] ?? 'Unnamed Product'),
//                   subtitle: Text('Price: ${data['price']}'),
//                   trailing: Text('Stock: ${data['stock']}'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_farm_app/services/database_service.dart';
import 'package:fresh_farm_app/screens/admin/add_product_screen.dart'; // Import to navigate

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage_products';
  const ManageProductsScreen({super.key});

  // --- 1. DELETE FUNCTION ---
  Future<void> _deleteProduct(BuildContext context, String productId) async {
    // Confirm before deleting
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await DatabaseService.instance.deleteProduct(productId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product deleted"), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  // --- 2. EDIT FUNCTION ---
  Future<void> _editProduct(BuildContext context, String docId, Map<String, dynamic> data) async {
    // Navigate to AddProductScreen and pass the ID and Data
    // The AddProductScreen we updated earlier handles these arguments
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen(
        productId: docId,
        productData: data,
       ),
      ),

      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Manage Products'),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.fetchProductsForAdmin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load products'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final docId = docs[index].id;
              final data = docs[index].data() as Map<String, dynamic>;
              final imageUrl = data['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                elevation: 2,
                child: ListTile(
                  // Show Image
                  leading: CircleAvatar(
                    // backgroundImage: NetworkImage(imageUrl),
                    // onImageError: (exception, stackTrace) => const Icon(Icons.image_not_supported),
                    backgroundColor: Colors.grey[200],
                    radius: 20,
                    child: ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Show Details
                  title: Text(
                    data['name'] ?? 'Unnamed Product',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'KES ${data['price']} | Stock: ${data['stock']}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  
                  // Show Action Buttons (Edit & Delete)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        tooltip: "Edit Product",
                        onPressed: () => _editProduct(context, docId, data),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: "Delete Product",
                        onPressed: () => _deleteProduct(context, docId),
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
}
