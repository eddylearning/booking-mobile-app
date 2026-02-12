import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  static const routeName = '/help';
  const HelpScreen({super.key});

    // Add this function inside your HelpScreen class
  Future<void> _showContactDialog(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.getUser;
    
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact Support"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: "Subject"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: "Message"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (subjectController.text.isEmpty || messageController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              // Close dialog
              Navigator.pop(context);

              // Show loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Sending message...")),
              );

              try {
                // Call Cloud Function
                await FirebaseFunctions.instance.httpsCallable('sendSupportEmail').call({
                  'subject': subjectController.text,
                  'message': messageController.text,
                  'userEmail': currentUser?.email ?? 'unknown',
                  'username': currentUser?.username ?? 'Guest',
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Message sent successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to send: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  // Helper function to launch URLs (Phone, Email, etc)
Future<void> _launchUrl(String urlString) async {
  // 1. Parse the string into a URI object
  final Uri uri = Uri.parse(urlString);
  
  // 2. Call the actual 'launchUrl' function from the package
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $urlString');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const TitlesTextWidget(label: "Frequently Asked Questions", fontSize: 18),
          const SizedBox(height: 10),

          // FAQ Item 1
          _buildFAQItem(
            question: "How do I place an order?",
            answer: "Browse products, add them to your cart, and proceed to checkout. You will receive an M-Pesa prompt to complete payment.",
          ),
          
          // FAQ Item 2
          _buildFAQItem(
            question: "What payment methods do you accept?",
            answer: "We currently accept M-Pesa payments. Ensure you have sufficient funds in your M-Pesa account.",
          ),

          // FAQ Item 3
          _buildFAQItem(
            question: "How long does delivery take?",
            answer: "Orders are typically delivered within 24-48 hours depending on your location.",
          ),

          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 20),

          const TitlesTextWidget(label: "Contact Us", fontSize: 18),
          const SizedBox(height: 10),

          // Contact Card: Call
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(Icons.call, color: Colors.white),
              ),
              title: const Text("Call Support"),
              subtitle: const Text("072923..."),
              onTap: () => _launchUrl('tel:0729237606'),
            ),
          ),

          const SizedBox(height: 10),

          // Contact Card: Email
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.email, color: Colors.white),
              ),
              title: const Text("Email Us"),
              subtitle: const Text("support@freshfarm.com"),
              //luanch users email app
              // onTap: () => _launchUrl('mailto:support@freshfarm.com'),
              onTap: () => _showContactDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: const Icon(IconlyBroken.info_square),
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}