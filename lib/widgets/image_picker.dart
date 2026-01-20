import 'dart:typed_data';
import 'package:flutter/material.dart';

class PickImageWidget extends StatelessWidget {
  final Uint8List? pickedImageBytes;
  final Function() onTap;
  const PickImageWidget({
    required this.pickedImageBytes,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey),
          shape: BoxShape.circle,
        ),
        child: pickedImageBytes == null
            ? const Icon(
                Icons.camera_enhance,
                size: 40,
                color: Colors.grey,
              )
            : CircleAvatar(
                backgroundImage: MemoryImage(pickedImageBytes!),
              ),
      ),
    );
  }
}