import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Your banner image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ham.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

     ElevatedButton(
      onPressed: () {
      Navigator.pushNamed(context, "/signup");
      },
      child: const Text("Create Account"),
      ),


          Text(
            "Welcome to Shop App",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),

          const SizedBox(height: 20),

          // Dark/Light toggle with icon
          ElevatedButton.icon(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(
              themeProvider.isDarkTheme ? Icons.nights_stay : Icons.wb_sunny,
              color: Colors.white,
            ),
            label: Text(
              themeProvider.isDarkTheme ? "Dark Mode" : "Light Mode",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
// https://console.firebase.google.com/project/shopke-4b83a/overview?hl=en