import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresh_farm_app/providers/product_provider.dart';
import 'package:fresh_farm_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:fresh_farm_app/widgets/image_picker.dart'; // Import correct widget
// import 'package:fresh_farm_app/widgets/titles_text_widget.dart';
import 'package:image_picker/image_picker.dart';

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
  
  // --- ADDED IMAGE PICKER STATE ---
  File? _imageFile;
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

  // --- ADDED IMAGE PICKING LOGIC ---
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final provider = Provider.of<ProductProvider>(context, listen: false);

      // 1. IMAGE LOGIC:
      // If you are uploading to Cloudinary, do it here and get the URL.
      // For now, we use the old image (if editing) or a placeholder.
      String finalImageUrl;
      
      if (_imageFile != null) {
         // TODO: Upload _imageFile to Cloudinary here and save URL to finalImageUrl
         finalImageUrl = "https://via.placeholder.com/150"; // Placeholder
      } else {
         finalImageUrl = widget.productData?['imageUrl'] ?? "https://via.placeholder.com/150";
      }

      final Map<String, dynamic> productMap = {
        'name': _nameController.text.trim(),
        'price': double.parse(_priceController.text),
        'stock': int.parse(_stockController.text),
        'category': _categoryController.text.trim(),
        'description': "Fresh farm produce",
        'imageUrl': finalImageUrl,
        'createdAt': Timestamp.now(),
      };

      if (_isEditing) {
        await provider.updateProduct(widget.productId!, productMap);
      } else {
        await provider.addProduct(productMap);
      }

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context);
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
              // FIXED: Correct Case, Removed const, Added function/pickedImage
              imagePickerWidget(
                pickedImage: _imageFile,
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
  
  imagePickerWidget({File? pickedImage, required Future<void> Function() function}) {}
}