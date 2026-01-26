
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 30),

//             // Profile Avatar
//             CircleAvatar(
//               radius: 55,
//               backgroundColor: Colors.blue.shade100,
//               child: const CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                   'https://i.pravatar.cc/300',
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Name
//             const Text(
//               'user',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 6),

//             // Email
//             const Text(
//               'user@email.com',
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),

//             const SizedBox(height: 24),

//             // Info Section
//             _buildInfoTile(
//               icon: Icons.phone,
//               title: 'Phone',
//               value: '+1 234 567 890',
//             ),
//             _buildInfoTile(
//               icon: Icons.location_on,
//               title: 'Location',
//               value: 'New York, USA',
//             ),
//             _buildInfoTile(
//               icon: Icons.person,
//               title: 'Username',
//               value: '@userdoe',
//             ),

//             const SizedBox(height: 30),

//             // Buttons
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       icon: const Icon(Icons.edit),
//                       label: const Text('Edit Profile'),
//                       onPressed: () {
//                         // Navigate to edit profile
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: OutlinedButton.icon(
//                       icon: const Icon(Icons.logout),
//                       label: const Text('Logout'),
//                       onPressed: () {
//                         // Handle logout
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget _buildInfoTile({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(title),
//       subtitle: Text(value),
//     );
//   }
// }


//without scaffold
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Theme colors for Dark Mode support
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          // Profile Avatar
          CircleAvatar(
            radius: 55,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/300',
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            'John Doe', // TODO: Replace with actual user data from AuthProvider
            style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 6),

          // Email
          Text(
            'john.doe@example.com', // TODO: Replace with actual user data
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
          ),

          const SizedBox(height: 24),

          // Info Section
          _buildInfoTile(
            icon: Icons.phone,
            title: 'Phone',
            value: '+254 700 000 000',
            theme: theme,
          ),
          _buildInfoTile(
            icon: Icons.location_on,
            title: 'Location',
            value: 'Nairobi, Kenya',
            theme: theme,
          ),
          _buildInfoTile(
            icon: Icons.person,
            title: 'Username',
            value: '@johndoe',
            theme: theme,
          ),

          const SizedBox(height: 30),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              onPressed: () {
                // TODO: Navigate to Edit Profile Screen
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () {
                // TODO: Call AuthProvider to sign out
                // Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to create info tiles
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
