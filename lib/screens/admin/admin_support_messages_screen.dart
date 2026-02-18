import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';

class AdminSupportMessagesScreen extends StatelessWidget {
  static const routeName = '/admin_support_messages';
  const AdminSupportMessagesScreen({super.key});

  Future<void> _updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('support_messages')
        .doc(docId)
        .update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('support_messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: SubtitleTextWidget(label: 'No support messages yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final status = (data['status'] ?? 'new').toString();
              final createdAt = data['createdAt'] as Timestamp?;
              final date = createdAt?.toDate();

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  title: TitlesTextWidget(
                    label: data['subject']?.toString().isNotEmpty == true
                        ? data['subject'].toString()
                        : 'No Subject',
                    fontSize: 16,
                  ),
                  subtitle: SubtitleTextWidget(
                    label:
                        '${data['username'] ?? 'Guest'} (${data['userEmail'] ?? 'unknown'})',
                    fontSize: 12,
                  ),
                  trailing: Chip(
                    label: Text(status.toUpperCase()),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SubtitleTextWidget(
                        label: date == null
                            ? 'Date: Unknown'
                            : 'Date: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        data['message']?.toString() ?? '',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: status == 'in_progress'
                                ? null
                                : () => _updateStatus(doc.id, 'in_progress'),
                            child: const Text('Mark In Progress'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: status == 'resolved'
                                ? null
                                : () => _updateStatus(doc.id, 'resolved'),
                            child: const Text('Mark Resolved'),
                          ),
                        ),
                      ],
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
