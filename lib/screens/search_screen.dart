
// import 'package:flutter/material.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   // Sample data
//   final List<String> _allItems = [
//     'Apple',
//     'Banana',
//     'Orange',
//     'Mango',
//     'Pineapple',
//     'Strawberry',
//     'Grapes',
//   ];

//   List<String> _filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _filteredItems = _allItems;
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       _filteredItems = _allItems
//           .where(
//             (item) => item.toLowerCase().contains(query.toLowerCase()),
//           )
//           .toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: _onSearchChanged,
//               decoration: InputDecoration(
//                 hintText: 'Search...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _filteredItems.isEmpty
//                 ? const Center(
//                     child: Text('No results found'),
//                   )
//                 : ListView.builder(
//                     itemCount: _filteredItems.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(_filteredItems[index]),
//                         onTap: () {
//                           // Handle item tap
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }



//without scaffold
import 'package:flutter/material.dart';

// Dummy Product Model for demonstration purposes
// TODO: Import your actual Product model from data/models/product.dart
class Product {
  final String name;
  final String category;
  final double price;

  Product({required this.name, required this.category, required this.price});
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // TODO: Replace this dummy list with data from ProductProvider
  final List<Product> _allItems = [
    Product(name: 'Fresh Apples', category: 'Fruits', price: 150),
    Product(name: 'Bananas', category: 'Fruits', price: 100),
    Product(name: 'Carrots', category: 'Vegetables', price: 80),
    Product(name: 'Mangoes', category: 'Fruits', price: 120),
    Product(name: 'Spinach', category: 'Vegetables', price: 50),
  ];

  List<Product> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = _allItems;
      } else {
        _filteredItems = _allItems
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search for fresh produce...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        
        // Results List
        Expanded(
          child: _filteredItems.isEmpty
              ? Center(
                  child: Text(
                    'No products found',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (_, i) {
                    final item = _filteredItems[i];
                    return ListTile(
                      leading: const Icon(Icons.shopping_basket),
                      title: Text(item.name),
                      subtitle: Text("${item.category} • KES ${item.price}"),
                      onTap: () {
                        // TODO: Navigate to Product Details
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}