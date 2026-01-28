import 'package:flutter/material.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
import 'package:fresh_farm_app/services/database_service.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.getUser?.uid;

    // If user is not logged in
    if (userId == null) {
      return const Center(child: Text("Please login to view orders"));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService.instance.getUserOrders(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                TitlesTextWidget(label: "No orders yet"),
                SubtitleTextWidget(label: "Your fresh orders will appear here"),
              ],
            ),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index].data() as Map<String, dynamic>;
            final Timestamp timestamp = order['timestamp'];
            final DateTime date = timestamp.toDate();
            final String status = order['status'] ?? 'Unknown';
            final double total = order['totalAmount']?.toDouble() ?? 0.0;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: ID and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitlesTextWidget(
                          label: "Order #${orders[index].id.substring(0, 8)}",
                          fontSize: 16,
                        ),
                        _buildStatusChip(status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Date
                    SubtitleTextWidget(
                      label: "Date: ${date.day}/${date.month}/${date.year}",
                      fontSize: 12,
                    ),
                    const Divider(),
                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SubtitleTextWidget(label: "Total Amount", fontSize: 14),
                        TitlesTextWidget(
                          label: "KES ${total.toStringAsFixed(2)}",
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper for Status Badge
  Widget _buildStatusChip(String status) {
    Color chipColor;
    if (status == 'paid') chipColor = Colors.green;
    else if (status == 'pending') chipColor = Colors.orange;
    else chipColor = Colors.grey;

    return Chip(
      label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10)),
      backgroundColor: chipColor.withOpacity(0.2),
      labelStyle: TextStyle(color: chipColor, fontWeight: FontWeight.bold),
    );
  }
}