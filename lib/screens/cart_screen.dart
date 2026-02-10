// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text.dart';
// import 'package:fresh_farm_app/widgets/title_text.dart';
// // import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// // import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

// class CartScreen extends StatelessWidget {
//   static const routeName = '/cart_screen';
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Title Section
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: TitlesTextWidget(
//               label: "My Cart",
//               fontSize: 24,
//             ),
//           ),
//         ),

//         const Divider(),

//         // List Area
//         Expanded(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.shopping_cart_outlined,
//                   size: 80,
//                   color: Colors.grey.withOpacity(0.5),
//                 ),
//                 const SizedBox(height: 20),
//                 const TitlesTextWidget(label: "Cart is empty"),
//                 SubtitleTextWidget(
//                   label: "Start adding fresh products!",
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Sticky Checkout Area (Bottom of content)
//         Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.2),
//                 spreadRadius: 1,
//                 blurRadius: 10,
//                 offset: const Offset(0, -3), // Shadow pointing up
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const TitlesTextWidget(label: "Total:", fontSize: 16),
//                   const TitlesTextWidget(label: "KES 0.00", fontSize: 18),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // TODO: Navigate to Checkout
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   child: const TitlesTextWidget(label: "Checkout", fontSize: 16, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 10), // Extra padding for bottom safe area
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fresh_farm_app/providers/cart_provider.dart';
import 'package:fresh_farm_app/screens/checkout_screen.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.cartItems;
        final itemsList = cartItems.values.toList();

        return Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TitlesTextWidget(
                  label: 'My Cart (${itemsList.length})',
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(),

            // Cart Items
            Expanded(
              child: itemsList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 20),
                          const TitlesTextWidget(label: 'Cart is empty'),
                          const SubtitleTextWidget(
                            label: 'Start adding fresh products!',
                            fontSize: 14,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemsList.length,
                      itemBuilder: (context, index) {
                        final cartItem = itemsList[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            leading: Image.network(
                              cartItem.product.imageUrl,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(cartItem.product.name),
                            subtitle: Text('Qty: ${cartItem.quantity}'),
                            trailing: Text(
                              'KES ${(cartItem.totalPrice).toStringAsFixed(2)}',
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Checkout Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitlesTextWidget(label: 'Total:', fontSize: 16),
                      TitlesTextWidget(
                        label:
                            'KES ${cartProvider.totalAmount.toStringAsFixed(2)}',
                        fontSize: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: itemsList.isEmpty
                          ? null
                          : () {
                              Navigator.pushNamed(
                                context,
                                CheckoutScreen.routeName,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: itemsList.isEmpty
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      ),
                      child: const TitlesTextWidget(
                        label: 'Checkout',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
