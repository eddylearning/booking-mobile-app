// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:fresh_farm_app/models/product_model.dart';
// import 'package:fresh_farm_app/providers/cart_provider.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text.dart';
// import 'package:fresh_farm_app/widgets/title_text.dart';

// class ProductDetailsScreen extends StatelessWidget {
//   static const routeName = '/product_details';
//   const ProductDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 1. Get the Product ID passed from HomeScreen
//     final productId = ModalRoute.of(context)!.settings.arguments as String;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Product Details"),
//       ),
//       body: FutureBuilder<DocumentSnapshot>(
//         // 2. Fetch specific product from Firestore
//         future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return const Center(child: Text("Error loading product"));
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text("Product not found"));
//           }

//           // 3. Extract Data
//           final data = snapshot.data!.data() as Map<String, dynamic>;
          
//           // Create a ProductModel object to make things easier
//           final product = ProductModel(
//             id: snapshot.data!.id,
//             name: data['name'] ?? 'Unknown Product', // Mapping 'name' to 'title'
//             price: (data['price'] ?? 0).toDouble(),
//             imageUrl: data['imageUrl'] ?? '',
//             description: data['description'] ?? 'No description available.',
//             category: data['category'] ?? 'General', 
//             stock:data['stock']??0,
//              createdAt:Timestamp.now(),
//           );

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Product Image
//                 Center(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       product.imageUrl,
//                       height: 250,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => 
//                           const Icon(Icons.image_not_supported, size: 100),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Title & Price
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: TitlesTextWidget(
//                         label: product.name,
//                         fontSize: 22,
//                         maxLines: 2,
//                       ),
//                     ),
//                     TitlesTextWidget(
//                       label: "KES ${product.price.toStringAsFixed(2)}",
//                       fontSize: 20,
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                   ],
//                 ),
                
//                 const Divider(height: 40),

//                 // Description
//                 const TitlesTextWidget(label: "Description", fontSize: 18),
//                 const SizedBox(height: 10),
//                 SubtitleTextWidget(
//                   label: product.description,
//                   fontSize: 16,
//                   fontWeight: FontWeight.normal,
//                 ),

//                 const SizedBox(height: 50),

//                 // Add to Cart Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       // 4. Add to Cart
//                       context.read<CartProvider>().addProductToCart(
//                         product: product,
//                       );
                      
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Added to Cart!"),
//                           backgroundColor: Colors.green,
//                         ),
//                       );
//                     },
//                     icon: const Icon(Icons.shopping_cart),
//                     label: const Text("Add to Cart", style: TextStyle(fontSize: 18)),
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fresh_farm_app/models/product_model.dart';
import 'package:fresh_farm_app/providers/cart_provider.dart';
import 'package:fresh_farm_app/screens/cart_screen.dart'; // Ensure this is imported
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product_details';
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- FIX: Safe Argument Handling ---
    // 1. Get the arguments safely without casting immediately
    final Object? args = ModalRoute.of(context)?.settings.arguments;

    // 2. Check if args is missing or not a String
    if (args == null || args is! String || args.isEmpty) {
      // Return a user-friendly error screen instead of crashing
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Error: No Product ID found.\n\nPlease ensure you are passing the ID correctly from the Home Screen using:\nNavigator.pushNamed(context, route, arguments: product.id);",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      );
    }

    // 3. Now we are sure productId is a valid String
    final String productId = args;
    // ------------------------------------

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                final itemCount = cartProvider.cartItems.length;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      onPressed: () {
                        Navigator.pushNamed(context, CartScreen.routeName);
                      },
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 0,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$itemCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading product"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Product not found in database"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          
          final product = ProductModel(
            id: snapshot.data!.id,
            name: data['name'] ?? 'Unknown Product',
            price: (data['price'] ?? 0).toDouble(),
            imageUrl: data['imageUrl'] ?? '',
            description: data['description'] ?? 'No description available.',
            category: data['category'] ?? 'General', 
            stock: data['stock'] ?? 0,
            createdAt: Timestamp.now(),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TitlesTextWidget(
                        label: product.name,
                        fontSize: 22,
                        maxLines: 2,
                      ),
                    ),
                    TitlesTextWidget(
                      label: "KES ${product.price.toStringAsFixed(2)}",
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                
                const Divider(height: 40),

                const TitlesTextWidget(label: "Description", fontSize: 18),
                const SizedBox(height: 10),
                SubtitleTextWidget(
                  label: product.description,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartProvider>().addProductToCart(
                        product: product,
                      );
                      
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Added to Cart!"),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                          action: SnackBarAction(
                            label: "VIEW CART",
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pushNamed(context, CartScreen.routeName);
                            },
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Add to Cart", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}