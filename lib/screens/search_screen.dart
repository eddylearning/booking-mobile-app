
import 'package:flutter/material.dart';

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
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _allItems = [
    'Apple',
    'Banana',
    'Orange',
    'Mango',
    'Pineapple',
    'Strawberry',
    'Grapes',
  ];

  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
              item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredItems.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (_, i) =>
                      ListTile(title: Text(_filteredItems[i])),
                ),
        ),
      ],
    );
  }
}
