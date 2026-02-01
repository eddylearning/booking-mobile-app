
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
import 'package:fresh_farm_app/screens/auth/login_screen.dart' hide TitlesTextWidget, SubtitleTextWidget;
import 'package:fresh_farm_app/screens/auth/signup_screen.dart';
import 'package:fresh_farm_app/screens/edit_profile_screen.dart';
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

    // Check if user is logged in or Guest
    final bool isGuest = (user == null || user.username.isEmpty);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 55,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: !isGuest && user.userImage.isNotEmpty
                    ? NetworkImage(user.userImage)
                    : null,
                child: isGuest || user.userImage.isEmpty
                    ? Text(
                        isGuest ? "G" : user.username[0].toUpperCase(),
                        style: TextStyle(fontSize: 40, color: theme.colorScheme.primary),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            // Name
            TitlesTextWidget(
              label: isGuest ? "Guest User" : user.username,
              fontSize: 24,
              color: theme.textTheme.headlineSmall?.color,
            ),

            const SizedBox(height: 6),

            // Email
            SubtitleTextWidget(
              label: isGuest ? "Please login or register" : user.email,
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),

            const SizedBox(height: 24),

            // Info Section (Hide for guests or show placeholder)
            _buildInfoTile(
              icon: Icons.person,
              title: 'Username',
              value: isGuest ? 'Guest' : user.username,
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
              value: isGuest ? 'guest' : user.role,
              theme: theme,
            ),

            const SizedBox(height: 30),

            // --- CONDITIONAL BUTTONS ---

            if (isGuest) ...[
              // GUEST: Show Create Account
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const TitlesTextWidget(label: 'Create Account', color: Colors.white),
                  onPressed: () {
                    // Navigate to Signup
                    Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              // LOGGED IN: Show Edit Profile
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: TitlesTextWidget(label: 'Edit Profile', color: theme.colorScheme.primary),
                  onPressed: () {
                    // TODO: Navigate to Edit Profile Screen
                    Navigator.pushNamed(context, EditProfileScreen.routeName);
                  },
                ),
              ),
              const SizedBox(height: 12),
              // LOGGED IN: Show Logout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const TitlesTextWidget(label: 'Logout', color: Colors.white),
                  onPressed: () async {
                    // IMPLEMENTED LOGOUT LOGIC
                     userProvider.clearUser();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
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