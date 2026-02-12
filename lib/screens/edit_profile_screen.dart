// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:provider/provider.dart';
// import 'package:fresh_farm_app/models/user_model.dart';
// import 'package:fresh_farm_app/providers/user_provider.dart';
// // import 'package:fresh_farm_app/widgets/image_picker.dart';
// // import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// // import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfileScreen extends StatefulWidget {
//   static const routeName = '/edit_profile';
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with current user data
//     final user = Provider.of<UserProvider>(context, listen: false).getUser;
//     _nameController = TextEditingController(text: user?.username ?? '');
//     if (user?.userImage != null && user!.userImage.isNotEmpty) {
//       // We can't easily set File from String without downloading it, 
//       // so we assume user picks new image or keeps old one.
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) return;

//     final userProvider = Provider.of<UserProvider>(context, listen: false);
    
//     // For this demo, we are just updating Name. 
//     // Image upload to Cloudinary would go here.
//     // We will pass the existing image URL or null if we aren't handling upload yet.
//     final UserModel? currentUser = userProvider.getUser;
//     final String currentImage = currentUser?.userImage ?? '';

//     await userProvider.updateProfile(
//       username: _nameController.text.trim(),
//       imageUrl: currentImage, // Keeping same image for now
//     );

//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const TitlesTextWidget(label: 'Edit Profile')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // Image Picker
//               Center(
//                 child: imagePickerWidget(
//                   pickedImage: _imageFile,
//                   function: _pickImage,
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Name Input
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Username",
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return "Please enter name";
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 30),

//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _saveProfile,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).colorScheme.primary,
//                   ),
//                   child: const TitlesTextWidget(label: "Save Changes", color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget? imagePickerWidget({File? pickedImage, required Future<void> Function() function}) {
//     return null;
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:fresh_farm_app/models/user_model.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:cached_network_image/cached_network_image.dart'; // Optional: use this for better loading

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit_profile';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  
  // Changed from File? to Uint8List? to match RegisterScreen logic
  Uint8List? _pickedImageBytes; 
  String? _pickedImageName;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    _nameController = TextEditingController(text: user?.username ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageName = image.name;
      });
    }
  }

  // --- 1. Cloudinary Upload Logic (Same as Register Screen) ---
  Future<String?> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
    final cloudName = 'dhzwors6d'; // Ensure this matches your Register Screen
    final uploadPreset = 'e-commerce'; // Ensure this matches
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    
    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = uploadPreset;
    request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: fileName));
    
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['secure_url'];
    }
    return null;
  }

  Future<void> _saveProfile() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final UserModel? currentUser = userProvider.getUser;

    try {
      String finalImageUrl = currentUser?.userImage ?? '';

      // 2. Check if user picked a new image
      if (_pickedImageBytes != null) {
        final uploadUrl = await uploadImageToCloudinary(_pickedImageBytes!, _pickedImageName ?? 'profile.jpg');
        if (uploadUrl != null) {
          finalImageUrl = uploadUrl;
        } else {
          throw Exception('Image upload failed');
        }
      }

      // 3. Update Profile in Provider
      // Ensure your UserProvider has this method accepting username and imageUrl
      await userProvider.updateProfile(
        username: _nameController.text.trim(),
        imageUrl: finalImageUrl,
      );

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context); // Go back to profile
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(title: const TitlesTextWidget(label: 'Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 4. Image Picker Widget
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _buildProfileImage(user),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Name Input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please enter name";
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const TitlesTextWidget(label: "Save Changes", color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to decide which image to show
  ImageProvider? _buildProfileImage(UserModel? user) {
    // If a new image is picked, show it
    if (_pickedImageBytes != null) {
      return MemoryImage(_pickedImageBytes!);
    }
    // Otherwise show the existing one
    if (user?.userImage != null && user!.userImage.isNotEmpty) {
      return NetworkImage(user.userImage);
    }
    return null;
  }
}