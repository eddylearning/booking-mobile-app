// import 'dart:convert';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   bool _obscurePassword = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Account"),
//         centerTitle: true,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(20),

//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [

//               Text(
//                 "Sign Up",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).textTheme.bodyLarge!.color,
//                 ),
//               ),

//               const SizedBox(height: 25),

//               // NAME
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: "Full Name",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter your name" : null,
//               ),

//               const SizedBox(height: 20),

//               // EMAIL
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value!.contains("@") ? null : "Enter a valid email",
//               ),

//               const SizedBox(height: 20),

//               // PASSWORD
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: _obscurePassword,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscurePassword = !_obscurePassword;
//                       });
//                     },
//                   ),
//                 ),
//                 validator: (value) =>
//                     value!.length < 6 ? "Password must be 6+ characters" : null,
//               ),

//               const SizedBox(height: 30),

//               // SIGN-UP BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // Example: Navigate to Home Screen
//                       Navigator.pushNamed(context, "/home");

//                       // You can replace this with Firebase or your backend code
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Account Created!")),
//                       );
//                     }
//                   },
//                   child: const Text(
//                     "Create Account",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 15),

//               // Already have account?
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, "/login");
//                   },
//                   child: const Text("Already have an account? Login"),
//                 ),
//               ),

//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:iconly/iconly.dart';

import 'package:fresh_farm_app/utils/my_validators.dart';
import 'package:fresh_farm_app/models/user_model.dart';
import 'package:fresh_farm_app/screens/auth/login_screen.dart';
import 'package:fresh_farm_app/services/my_app_functions.dart';
import 'package:fresh_farm_app/widgets/image_picker.dart'; // PickImageWidget


class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Uint8List? _pickedImageBytes;
  String? _pickedImageName;
  bool obscureText = true;
  late final TextEditingController _nameController, _emailController, _passwordController, _repeatPasswordController;
  late final FocusNode _nameFocusNode, _emailFocusNode, _passwordFocusNode, _repeatPasswordFocusNode;
  
  // Default role for public registration is 'customer' 
  // map 'user' to 'customer' logic later.
  String role = 'customer'; 
  bool isLoading = false;
  late String userImageUrl;
  final _formkey = GlobalKey<FormState>();
  XFile? _pickedImage;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPasswordController.dispose();
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _repeatPasswordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
        if (image != null) { _pickedImageBytes = await image.readAsBytes(); _pickedImageName = image.name; setState(() {}); }
      },
      galleryFCT: () async {
        final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) { _pickedImageBytes = await image.readAsBytes(); _pickedImageName = image.name; setState(() {}); }
      },
      removeFCT: () async { setState(() { _pickedImageBytes = null; _pickedImageName = null; }); },
    );
  }

  Future<String?> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
    final cloudName = 'dhzwors6d';
    final uploadPreset = 'e-commerce';
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

  Future<void> _registerFCT() async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;
    if (_pickedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Upload to Cloudinary
      userImageUrl = await uploadImageToCloudinary(_pickedImageBytes!, _pickedImageName ?? 'profile.jpg') ?? '';
      if (userImageUrl.isEmpty) throw Exception('Image upload failed');

      final newUser = UserModel(
        uid: userCredentials.user!.uid,
        email: _emailController.text.trim(),
        role: role, // This is 'customer'
        username: _nameController.text.trim(),
        userCart: [],
        userWish: [],
        userImage: userImageUrl,
        createdAt: Timestamp.now(),
      );

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set(newUser.toMap());

      // Send Email Verification
      await userCredentials.user!.sendEmailVerification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered! Please verify your email before logging in.')),
        );
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body:LoadngManager(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  const Text("AgriConnect", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      TitlesTextWidget(label: "Create Account"),
                      SubtitleTextWidget(label: "Join the farming community"),

                      const SizedBox(height:10),
                      //to login
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Already have an account? Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        ),
                        )
                    ]),  
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                    child: PickImageWidget(
                      pickedImageBytes: _pickedImageBytes,
                      onTap: () async => await localImagePicker(),
                    ),
                  ),
                  const SizedBox(height:20),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(hintText: 'Full Name', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_emailFocusNode),
                          validator: (value) => MyValidators.displayNamevalidator(value),
                        ),
                        const SizedBox(height: 13.0),
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(hintText: "Email address", prefixIcon: Icon(IconlyLight.message), border: OutlineInputBorder()),
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                          validator: (value) => MyValidators.emailValidator(value),
                        ),
                        const SizedBox(height: 13.0),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "***********",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(onPressed: () => setState(() => obscureText = !obscureText), icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off)),
                            border: const OutlineInputBorder()
                          ),
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_repeatPasswordFocusNode),
                          validator: (value) => MyValidators.passwordValidator(value),
                        ),
                        const SizedBox(height: 13.0),
                        TextFormField(
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Repeat password",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(onPressed: () => setState(() => obscureText = !obscureText), icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off)),
                            border: const OutlineInputBorder()
                          ),
                          validator: (value) => MyValidators.repeatPasswordValidator(value: value, password: _passwordController.text),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(12.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                            icon: const Icon(IconlyLight.add_user),
                            label: const Text("Sign up"),
                            onPressed: isLoading ? null : () async => await _registerFCT(),
                          ),
                          
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}