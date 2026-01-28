// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/screens/auth/signup_screen.dart';

// // without scaffold
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           height: 200,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/images/ham.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pushNamed(context, RegisterScreen.routeName);
//           },
//           child: const Text("Create Account"),
//         ),
//         const SizedBox(height: 20),
//         Text(
//           "Welcome to Agri shop App",
//           style: Theme.of(context)
//               .textTheme
//               .headlineSmall
//               ?.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fresh_farm_app/services/database_service.dart';
import 'package:fresh_farm_app/widgets/product_card.dart';
import 'package:fresh_farm_app/widgets/shimmer_loader.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TitlesTextWidget(
            label: "Fresh Produce",
            fontSize: 24,
          ),
          const SizedBox(height: 5),
          SubtitleTextWidget(
            label: "Fresh from the farm to your door",
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),

          // Grid inside ScrollView needs shrinkWrap and NeverScrollableScrollPhysics
          StreamBuilder(
            stream: DatabaseService.instance.getProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ProductsShimmer();
              }
              if (snapshot.hasError) {
                return Center(
                  heightFactor: 10,
                  child: TitlesTextWidget(label: "Error loading products", color: Colors.red),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  heightFactor: 10,
                  child: TitlesTextWidget(label: "No products found.", color: Colors.grey),
                );
              }

              final products = snapshot.data!.docs;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    productId: product.id,
                    title: product['name'],
                    price: product['price'].toDouble(),
                    imageUrl: product['imageUrl'] ?? 'https://via.placeholder.com/150',
                    onTap: () {
                      // TODO: Navigate to Product Detail
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}