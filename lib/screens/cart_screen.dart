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
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart'; // Ensure this matches main.dart
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TitlesTextWidget(
              label: "My Cart",
              fontSize: 24,
            ),
          ),
        ),

        const Divider(),

        // List Area
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Theme.of(context).disabledColor,
                ),
                const SizedBox(height: 20),
                TitlesTextWidget(label: "Cart is empty"),
                SubtitleTextWidget(
                  label: "Start adding fresh products!",
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ),

        // Sticky Checkout Area
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitlesTextWidget(label: "Total:", fontSize: 16),
                  TitlesTextWidget(label: "KES 0.00", fontSize: 18),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Checkout
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: TitlesTextWidget(
                    label: "Checkout",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}