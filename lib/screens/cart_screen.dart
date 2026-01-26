// import 'package:flutter/material.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State <CartScreen> createState() => CartScreenState();
// }

// class CartScreenState extends State <CartScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

import 'package:flutter/material.dart';

// Dummy Cart Item Model
// TODO: Import your actual CartItem model from data/models/cart_item.dart
class CartItem {
  final String name;
  final double price;
  final int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // TODO: Fetch this list from CartProvider
  final List<CartItem> _cartItems = [
    CartItem(name: 'Fresh Apples', price: 150, quantity: 2),
    CartItem(name: 'Spinach', price: 50, quantity: 1),
  ];

  double get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Note: You mentioned "without scaffold", but CartScreen usually needs 
      // its own AppBar unless it's a nested tab. 
      // Adjust this wrapper based on your MainWrapper implementation.
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, 
                       size: 80, 
                       color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.circle, size: 10),
                          title: Text(item.name),
                          subtitle: Text("KES ${item.price} each"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("x${item.quantity}"),
                              const SizedBox(width: 10),
                              Text(
                                "KES ${item.price * item.quantity}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
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
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', 
                              style: TextStyle(fontSize: 18)),
                          Text(
                            'KES $_totalPrice',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to Checkout Screen (M-Pesa Integration)
                            // Navigator.pushNamed(context, CheckoutScreen.routeName);
                          },
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}