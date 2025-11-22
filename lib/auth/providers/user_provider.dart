import 'dart:io';

import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final userProfileProvider = ChangeNotifierProvider<UserProfileNotifier>(
  (ref) => UserProfileNotifier(),
);

class UserProfileNotifier extends ChangeNotifier {
  Future<Map<String, String>> saveAadhaarDetailsToDb({
    required File aadhaarFront,
    File? aadhaarBack,
    required String userId,
  }) async {
    final urls = <String, String>{};

    final now = DateTime.now();
    final dateFolder =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    // CORRECT BUCKET (from your google-services.json)
    final storage = FirebaseStorage.instanceFor(
      bucket: AppConstants.storageBucketName,
    );

    Future<String> upload(File file, String path) async {
      print("📤 Uploading to: $path");
      final ref = storage.ref().child(path);

      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: "image/jpeg"),
      );

      final snap = await uploadTask.whenComplete(() {});
      final url = await snap.ref.getDownloadURL();

      print("✅ Uploaded: $url");
      return url;
    }

    try {
      urls["aadhaar_front_url"] = await upload(
        aadhaarFront,
        "userpics/$dateFolder/${userId}_aadhaar_front.jpg",
      );
    } catch (e) {
      print("❌ Front upload failed: $e");
    }

    if (aadhaarBack != null) {
      try {
        urls["aadhaar_back_url"] = await upload(
          aadhaarBack,
          "userpics/$dateFolder/${userId}_aadhaar_back.jpg",
        );
      } catch (e) {
        print("❌ Back upload failed: $e");
      }
    }

    return urls;
  }
}
