import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/models/user_model.dart';
import 'package:fresh_farm_app/providers/user_provider.dart';
// import 'package:fresh_farm_app/widgets/image_picker.dart';
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:fresh_farm_app/widgets/subtitle_text_widget.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/edit_profile';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    _nameController = TextEditingController(text: user?.username ?? '');
    if (user?.userImage != null && user!.userImage.isNotEmpty) {
      // We can't easily set File from String without downloading it, 
      // so we assume user picks new image or keeps old one.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // For this demo, we are just updating Name. 
    // Image upload to Cloudinary would go here.
    // We will pass the existing image URL or null if we aren't handling upload yet.
    final UserModel? currentUser = userProvider.getUser;
    final String currentImage = currentUser?.userImage ?? '';

    await userProvider.updateProfile(
      username: _nameController.text.trim(),
      imageUrl: currentImage, // Keeping same image for now
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TitlesTextWidget(label: 'Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Picker
              Center(
                child: imagePickerWidget(
                  pickedImage: _imageFile,
                  function: _pickImage,
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
  
  Widget? imagePickerWidget({File? pickedImage, required Future<void> Function() function}) {
    return null;
  }
}