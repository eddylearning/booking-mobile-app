
// //without scaffold
// import 'package:flutter/material.dart';

// // Dummy Product Model for demonstration purposes
// // TODO: Import your actual Product model from data/models/product.dart
// class Product {
//   final String name;
//   final String category;
//   final double price;

//   Product({required this.name, required this.category, required this.price});
// }

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   // TODO: Replace this dummy list with data from ProductProvider
//   final List<Product> _allItems = [
//     Product(name: 'Fresh Apples', category: 'Fruits', price: 150),
//     Product(name: 'Bananas', category: 'Fruits', price: 100),
//     Product(name: 'Carrots', category: 'Vegetables', price: 80),
//     Product(name: 'Mangoes', category: 'Fruits', price: 120),
//     Product(name: 'Spinach', category: 'Vegetables', price: 50),
//   ];

//   List<Product> _filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredItems = _allItems;
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredItems = _allItems;
//       } else {
//         _filteredItems = _allItems
//             .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Search Bar
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: TextField(
//             controller: _searchController,
//             onChanged: _onSearchChanged,
//             decoration: InputDecoration(
//               hintText: 'Search for fresh produce...',
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: Theme.of(context).colorScheme.surface,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//         ),
        
//         // Results List
//         Expanded(
//           child: _filteredItems.isEmpty
//               ? Center(
//                   child: Text(
//                     'No products found',
//                     style: Theme.of(context).textTheme.bodyLarge,
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: _filteredItems.length,
//                   itemBuilder: (_, i) {
//                     final item = _filteredItems[i];
//                     return ListTile(
//                       leading: const Icon(Icons.shopping_basket),
//                       title: Text(item.name),
//                       subtitle: Text("${item.category} • KES ${item.price}"),
//                       onTap: () {
//                         // TODO: Navigate to Product Details
//                       },
//                     );
//                   },
//                 ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fresh_farm_app/services/database_service.dart';
import 'package:fresh_farm_app/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  String _searchQuery = "";

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Manual Search Bar inside the body
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              hintText: "Search vegetables, fruits...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query.toLowerCase();
              });
            },
          ),
        ),
        
        // Results Area
        Expanded(
          child: StreamBuilder(
            stream: DatabaseService.instance.getProductsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final allProducts = snapshot.data!.docs;
              final filteredProducts = allProducts.where((product) {
                final name = product['name'].toString().toLowerCase();
                return name.contains(_searchQuery);
              }).toList();

              if (filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("No products found"),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(
                    productId: product.id,
                    title: product['name'],
                    price: product['price'].toDouble(),
                    imageUrl: product['imageUrl'] ?? 'https://via.placeholder.com/150',
                    onTap: () {},
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}