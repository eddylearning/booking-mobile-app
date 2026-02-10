import 'package:flutter/material.dart';
import 'package:fresh_farm_app/screens/order_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/models/cart_model.dart';
import 'package:fresh_farm_app/providers/cart_provider.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
import 'package:fresh_farm_app/services/payment_service.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isProcessing = false;
  final _uuid = const Uuid();

  @override
  void dispose() {
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.getUser;

    final cartItems = cartProvider.cartItems.values.toList();

    if (currentUser != null && _phoneController.text.isEmpty) {
      _phoneController.text = currentUser.phoneNumber ?? "";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const TitlesTextWidget(label: "Delivery Details", fontSize: 18),
            const SizedBox(height: 15),

            // Phone
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "M-Pesa Phone Number",
                prefixIcon: Icon(IconlyBold.call),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a phone number";
                }
                if (value.length < 10) {
                  return "Enter a valid phone number";
                }
                return null;
              },
            ),

            const SizedBox(height: 15),

            // Address
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Delivery Address",
                prefixIcon: Icon(IconlyBold.location),
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? "Enter delivery address" : null,
            ),

            const SizedBox(height: 30),

            // Order Summary
            const TitlesTextWidget(label: "Order Summary", fontSize: 18),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final CartModel cartItem = cartItems[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${cartItem.quantity} x ${cartItem.product.name}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      SubtitleTextWidget(
                        label:
                            "KES ${cartItem.totalPrice.toStringAsFixed(2)}",
                        fontSize: 14,
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(height: 30),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TitlesTextWidget(label: "Total Amount:", fontSize: 16),
                TitlesTextWidget(
                  label:
                      "KES ${cartProvider.totalAmount.toStringAsFixed(2)}",
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Pay Button
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isProcessing = true);

                          try {
                            final orderId = _uuid.v4();

                            await PaymentService.processMpesaPayment(
                              amount: cartProvider.totalAmount,
                              phone: _phoneController.text,
                              orderId: orderId,
                              context: context,
                              onSuccess: () {
                                cartProvider.clearCart();
                                Navigator.pushReplacementNamed(
                                  context,
                                  OrdersScreen.routeName,
                                );
                              },
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isProcessing = false);
                            }
                          }
                        }
                      },
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(IconlyBold.wallet),
                label: Text(
                  _isProcessing ? "Processing..." : "Pay with M-Pesa",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
