// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fresh_farm_app/providers/product_provider.dart';
// import 'package:fresh_farm_app/widgets/title_text.dart';
// import 'package:provider/provider.dart';
// // import 'package:fresh_farm_app/widgets/image_picker.dart'; // Import correct widget
// // import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
// import 'package:image_picker/image_picker.dart';

// class AddProductScreen extends StatefulWidget {
//   static const routeName = '/add_product';
//   final Map<String, dynamic>? productData; // For Edit
//   final String? productId; // For Edit

//   const AddProductScreen({super.key, this.productData, this.productId});

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _priceController;
//   late TextEditingController _stockController;
//   late TextEditingController _categoryController;
  
//   // --- ADDED IMAGE PICKER STATE ---
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();

//   bool _isEditing = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     _isEditing = widget.productId != null;
//     _nameController = TextEditingController(text: widget.productData?['name'] ?? '');
//     _priceController = TextEditingController(text: widget.productData?['price']?.toString() ?? '');
//     _stockController = TextEditingController(text: widget.productData?['stock']?.toString() ?? '');
//     _categoryController = TextEditingController(text: widget.productData?['category'] ?? 'Vegetables');
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _priceController.dispose();
//     _stockController.dispose();
//     _categoryController.dispose();
//     super.dispose();
//   }

//   // --- ADDED IMAGE PICKING LOGIC ---
//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   void _submitProduct() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       final provider = Provider.of<ProductProvider>(context, listen: false);

//       // 1. IMAGE LOGIC:
//       // If you are uploading to Cloudinary, do it here and get the URL.
//       // For now, we use the old image (if editing) or a placeholder.
//       String finalImageUrl;
      
//       if (_imageFile != null) {
//          // TODO: Upload _imageFile to Cloudinary here and save URL to finalImageUrl
//          finalImageUrl = "https://via.placeholder.com/150"; // Placeholder
//       } else {
//          finalImageUrl = widget.productData?['imageUrl'] ?? "https://via.placeholder.com/150";
//       }

//       final Map<String, dynamic> productMap = {
//         'name': _nameController.text.trim(),
//         'price': double.parse(_priceController.text),
//         'stock': int.parse(_stockController.text),
//         'category': _categoryController.text.trim(),
//         'description': "Fresh farm produce",
//         'imageUrl': finalImageUrl,
//         'createdAt': Timestamp.now(),
//       };

//       if (_isEditing) {
//         await provider.updateProduct(widget.productId!, productMap);
//       } else {
//         await provider.addProduct(productMap);
//       }

//       if (mounted) {
//         setState(() => _isLoading = false);
//         Navigator.pop(context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TitlesTextWidget(
//           label: _isEditing ? "Edit Product" : "Add Product",
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // FIXED: Correct Case, Removed const, Added function/pickedImage
//               imagePickerWidget(
//                 pickedImage: _imageFile,
//                 function: _pickImage,
//               ),
              
//               const SizedBox(height: 20),
              
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: "Product Name", border: OutlineInputBorder()),
//                 validator: (v) => v!.isEmpty ? "Enter name" : null,
//               ),
//               const SizedBox(height: 10),
              
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 10),
              
//               TextFormField(
//                 controller: _priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Price (KES)", border: OutlineInputBorder()),
//                 validator: (v) => v!.isEmpty ? "Enter price" : null,
//               ),
//               const SizedBox(height: 10),
              
//               TextFormField(
//                 controller: _stockController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Stock Quantity", border: OutlineInputBorder()),
//                 validator: (v) => v!.isEmpty ? "Enter stock" : null,
//               ),
//               const SizedBox(height: 30),
              
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _submitProduct,
//                 child: _isLoading 
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : TitlesTextWidget(label: _isEditing ? "Update" : "Save", color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   imagePickerWidget({File? pickedImage, required Future<void> Function() function}) {}
// }

import 'dart:convert';
import 'dart:typed_data'; // Changed from dart:io
import 'dart:typed_data' as typed;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:fresh_farm_app/providers/product_provider.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add_product';
  final Map<String, dynamic>? productData; // For Edit
  final String? productId; // For Edit

  const AddProductScreen({super.key, this.productData, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryController;

  // Changed to Uint8List for Cloudinary compatibility
  typed.Uint8List? _pickedImageBytes; 
  String? _pickedImageName;
  final ImagePicker _picker = ImagePicker();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    _isEditing = widget.productId != null;
    _nameController = TextEditingController(text: widget.productData?['name'] ?? '');
    _priceController = TextEditingController(text: widget.productData?['price']?.toString() ?? '');
    _stockController = TextEditingController(text: widget.productData?['stock']?.toString() ?? '');
    _categoryController = TextEditingController(text: widget.productData?['category'] ?? 'Vegetables');
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // --- 1. CLOUDINARY UPLOAD LOGIC (Copied from RegisterScreen) ---
  Future<String?> uploadImageToCloudinary(typed.Uint8List imageBytes, String fileName) async {
    final cloudName = 'dhzwors6d'; // Ensure this matches your project
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

  // --- 2. IMAGE PICKING LOGIC ---
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

    void _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final provider = Provider.of<ProductProvider>(context, listen: false);

      try {
        String finalImageUrl;

        // --- IMAGE LOGIC ---
        if (_pickedImageBytes != null) {
          // Upload new image
          final uploadUrl = await uploadImageToCloudinary(_pickedImageBytes!, _pickedImageName ?? 'product.jpg');
          if (uploadUrl != null) {
            finalImageUrl = uploadUrl;
          } else {
            throw Exception('Image upload failed');
          }
        } else {
          // Keep existing image (if editing) or use placeholder (if adding)
          finalImageUrl = widget.productData?['imageUrl'] ?? "https://via.placeholder.com/150";
        }

        // --- DEFINE TIMESTAMP VARIABLE ---
        final Timestamp now = Timestamp.now();

        final Map<String, dynamic> productMap = {
          'name': _nameController.text.trim(),
          'price': double.parse(_priceController.text),
          'stock': int.parse(_stockController.text),
          'category': _categoryController.text.trim(),
          'description': "Fresh farm produce",
          'imageUrl': finalImageUrl,
          
          // Use 'now' variable defined above
          // 'createdAt': _isEditing ? widget.productData?['createdAt'] : now,
          
          // Optional: Add updatedAt if you want to track edits
          'updatedAt': now,
        };

        if (_isEditing) {
          await provider.updateProduct(widget.productId!, productMap);
        } else {
          await provider.addProduct(productMap);
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product Saved Successfully!'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitlesTextWidget(
          label: _isEditing ? "Edit Product" : "Add Product",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // FIXED: Implemented the Widget
              imagePickerWidget(
                pickedImage: _pickedImageBytes,
                existingUrl: widget.productData?['imageUrl'],
                function: _pickImage,
              ),
              
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price (KES)", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Enter price" : null,
              ),
              const SizedBox(height: 10),
              
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Stock Quantity", border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? "Enter stock" : null,
              ),
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _submitProduct,
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : TitlesTextWidget(label: _isEditing ? "Update" : "Save", color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // --- 3. WIDGET IMPLEMENTATION ---
  Widget imagePickerWidget({
    required typed.Uint8List? pickedImage,
    String? existingUrl, // Added to show current image when editing
    required VoidCallback function,
  }) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: pickedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(pickedImage, fit: BoxFit.cover),
              )
            : (existingUrl != null && existingUrl.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(existingUrl, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Tap to select image", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
      ),
    );
  }
}