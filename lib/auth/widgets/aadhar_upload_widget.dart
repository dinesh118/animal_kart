import 'dart:io';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:animal_kart_demo2/utils/svg_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AadhaarUploadWidget extends StatelessWidget {
  final File? file;
  final String title;
  final VoidCallback onRemove;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final bool isFrontImage;

  const AadhaarUploadWidget({
    super.key,
    required this.file,
    required this.title,
    required this.onRemove,
    required this.onCamera,
    required this.onGallery,
    this.isFrontImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            /// ✅ NO UPLOAD LOGIC, ONLY STATIC PREVIEW
            if (file != null)
              _buildFilePreview()
            else
              _buildUploadButtons(),
          ],
        ),
      ),
    );
  }

  /// ✅ IMAGE PREVIEW WITH DELETE
  Widget _buildFilePreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file!,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.string(
                SvgUtils().deleteIcon,
                color: akRedColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ PICK FROM CAMERA OR GALLERY
  Widget _buildUploadButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_upload_outlined,
                size: 55,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onGallery,
                child: const Text(
                  "Upload Image",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Text("Upload photos of max size 10MB in JPG, JPEG"),
              const Text("or"),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: onCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text("Open Camera"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
