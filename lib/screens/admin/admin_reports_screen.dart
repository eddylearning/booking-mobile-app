import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:path_provider/path_provider.dart';

class AdminReportsScreen extends StatelessWidget {
  static const routeName = '/admin_reports';
  const AdminReportsScreen({super.key});

  Future<void> _downloadSalesReport() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    final rows = [
      ['Order ID', 'User ID', 'Date', 'Amount', 'Status', 'Payment Method'],
    ];

    for (var doc in snapshot.docs) {
      final d = doc.data();
      rows.add([
        doc.id,
        d['userId'],
        (d['timestamp'] as Timestamp).toDate().toString(),
        d['totalAmount'].toString(),
        d['status'],
        d['paymentMethod'],
      ]);
    }

final csv = const ListToCsvConverter().convert(rows);
    await _saveFile(csv, 'sales_report.csv');
  }

  Future<void> _downloadProductReport() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').get();

    final rows = [
      ['Product ID', 'Name', 'Price', 'Stock', 'Category'],
    ];

    for (var doc in snapshot.docs) {
      final d = doc.data();
      rows.add([
        doc.id,
        d['name'],
        d['price'].toString(),
        d['stock'].toString(),
        d['category'],
      ]);
    }

final csv = const ListToCsvConverter().convert(rows);
    await _saveFile(csv, 'products_report.csv');
  }

  Future<void> _saveFile(String content, String filename) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/$filename';
    final file = File(path);
    await file.writeAsString(content);

    debugPrint('Report saved to: $path');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(label: 'Reports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: const TitlesTextWidget(label: 'Sales Report (CSV)'),
              subtitle:
                  const Text('Download all orders and payment information'),
              trailing: const Icon(Icons.download),
              onTap: _downloadSalesReport,
            ),
            const Divider(),
            ListTile(
              title: const TitlesTextWidget(label: 'Inventory Report (CSV)'),
              subtitle: const Text('Download all products and stock'),
              trailing: const Icon(Icons.download),
              onTap: _downloadProductReport,
            ),
          ],
        ),
      ),
    );
  }
}
