
// //without scaffold
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Using Theme colors for Dark Mode support
//     final theme = Theme.of(context);

//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//       child: Column(
//         children: [
//           // Profile Avatar
//           CircleAvatar(
//             radius: 55,
//             backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
//             child: CircleAvatar(
//               radius: 50,
//               backgroundImage: const NetworkImage(
//                 'https://i.pravatar.cc/300',
//               ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // Name
//           Text(
//             'John Doe', // TODO: Replace with actual user data from AuthProvider
//             style: theme.textTheme.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),

//           const SizedBox(height: 6),

//           // Email
//           Text(
//             'john.doe@example.com', // TODO: Replace with actual user data
//             style: theme.textTheme.bodyMedium?.copyWith(
//                   color: theme.colorScheme.onSurface.withOpacity(0.6),
//                 ),
//           ),

//           const SizedBox(height: 24),

//           // Info Section
//           _buildInfoTile(
//             icon: Icons.phone,
//             title: 'Phone',
//             value: '+254 700 000 000',
//             theme: theme,
//           ),
//           _buildInfoTile(
//             icon: Icons.location_on,
//             title: 'Location',
//             value: 'Nairobi, Kenya',
//             theme: theme,
//           ),
//           _buildInfoTile(
//             icon: Icons.person,
//             title: 'Username',
//             value: '@johndoe',
//             theme: theme,
//           ),

//           const SizedBox(height: 30),

//           // Buttons
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.edit),
//               label: const Text('Edit Profile'),
//               onPressed: () {
//                 // TODO: Navigate to Edit Profile Screen
//               },
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               icon: const Icon(Icons.logout),
//               label: const Text('Logout'),
//               onPressed: () {
//                 // TODO: Call AuthProvider to sign out
//                 // Provider.of<AuthProvider>(context, listen: false).logout();
//               },
//             ),
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // Helper method to create info tiles
//   Widget _buildInfoTile({
//     required IconData icon,
//     required String title,
//     required String value,
//     required ThemeData theme,
//   }) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Icon(icon, color: theme.colorScheme.primary),
//       title: Text(title),
//       subtitle: Text(value),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fresh_farm_app/widgets/subtitle_text.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/models/user_model.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final UserModel? user = userProvider.getUser;

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
              backgroundImage: user?.userImage != null && user!.userImage.isNotEmpty
                  ? NetworkImage(user.userImage)
                  : null,
              child: (user?.userImage == null || user!.userImage.isEmpty)
                  ? Text(
                      user?.username[0].toUpperCase() ?? "U",
                      style: TextStyle(fontSize: 40, color: theme.colorScheme.primary),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // Name
          TitlesTextWidget(
            label: user?.username ?? "Guest User",
            fontSize: 24,
            color: theme.textTheme.headlineSmall?.color,
          ),

          const SizedBox(height: 6),

          // Email
          SubtitleTextWidget(
            label: user?.email ?? "No Email",
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),

          const SizedBox(height: 24),

          // Info Section
          _buildInfoTile(
            icon: Icons.person,
            title: 'Username',
            value: user?.username ?? 'Guest',
            theme: theme,
          ),
          _buildInfoTile(
            icon: Icons.location_on,
            title: 'Location',
            value: 'Nairobi, Kenya',
            theme: theme,
          ),
          _buildInfoTile(
            icon: Icons.security,
            title: 'Role',
            value: user?.role ?? 'user',
            theme: theme,
          ),

          const SizedBox(height: 30),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const TitlesTextWidget(label: 'Edit Profile', color: Colors.white),
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
              label: TitlesTextWidget(label: 'Logout', color: Colors.red),
              onPressed: () {
                // TODO: Call AuthProvider to sign out
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper method to create info tiles using the new widgets
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: TitlesTextWidget(label: title, fontSize: 16),
      subtitle: SubtitleTextWidget(label: value, fontSize: 14, color: Colors.grey),
    );
  }
}