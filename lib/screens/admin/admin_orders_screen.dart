import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_farm_app/services/database_service.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

class AdminOrdersScreen extends StatelessWidget {
  static const routeName = '/admin_orders';
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: "View Orders & Payments"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService.instance.getAllOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          
          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              final String status = data['status'] ?? 'pending';

              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: TitlesTextWidget(label: "Order #${order.id.substring(0, 8)}"),
                  subtitle: SubtitleTextWidget(
                    label: "KES ${data['totalAmount']} - $status",
                    fontSize: 12,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitlesTextWidget(label: "Update Status:"),
                              DropdownButton<String>(
                                value: status,
                                items: const ['pending', 'paid', 'delivered']
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (val) async {
                                  if (val != null) {
                                    DatabaseService.instance.updateOrderStatus(order.id, val);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SubtitleTextWidget(label: "User ID: ${data['userId']}"),
                          SubtitleTextWidget(label: "Payment: ${data['paymentMethod']}"),
                          SubtitleTextWidget(label: "Items: ${data['products'].length}"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}