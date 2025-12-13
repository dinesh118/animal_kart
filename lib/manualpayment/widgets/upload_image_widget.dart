// lib/manualpayment/widgets/upload_image_widget.dart
import 'package:flutter/material.dart';
import 'package:animal_kart_demo2/auth/widgets/aadhar_upload_widget.dart';

class UploadImageWidget extends StatelessWidget {
  final String title;
  final dynamic file;
  final double? uploadProgress;
  final bool isUploading;
  final bool isDeleting;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemove;
  final String? errorMessage;

  const UploadImageWidget({
    super.key,
    required this.title,
    required this.file,
    required this.uploadProgress,
    required this.isUploading,
    required this.isDeleting,
    required this.onCamera,
    required this.onGallery,
    required this.onRemove,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AbsorbPointer(
          absorbing: isUploading || isDeleting,
          child: Opacity(
            opacity: (isUploading || isDeleting) ? 0.6 : 1.0,
            child: AadhaarUploadWidget(
              title: title,
              file: file,
              isFrontImage: true,
              uploadProgress: uploadProgress,
              onCamera: onCamera,
              onGallery: onGallery,
              onRemove: onRemove,
            ),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}