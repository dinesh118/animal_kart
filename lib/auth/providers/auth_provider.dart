import 'dart:convert';
import 'dart:io';

import 'package:animal_kart_demo2/auth/models/user_details.dart';
import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

final authProvider = ChangeNotifierProvider<AuthController>(
  (ref) => AuthController(),
);

class AuthController extends ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

 
  UserProfile? _userProfile;
  UserProfile? get userProfile => _userProfile;


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================
  // ✅ LOGOUT
  // ============================
  Future<void> logout() async {
    try {
      _setLoading(true);

      await FirebaseAuth.instance.signOut();
      _userProfile = null;
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  
  Future<bool> verifyUser(String phone) async {
    _setLoading(true);

    try {
      final deviceDetails = await ApiServices.fetchDeviceDetails();

      final response = await http.post(
        Uri.parse("${AppConstants.apiUrl}/users/verify"),
        headers: {
          HttpHeaders.contentTypeHeader: AppConstants.applicationJson,
        },
        body: jsonEncode({
          'mobile': phone,
          'device_id': deviceDetails.id,
          'device_model': deviceDetails.model,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final bool isSuccess = data["status"] == "success";

        if (isSuccess && data["user"] != null) {
          _userProfile = UserProfile.fromJson(
            data["user"] as Map<String, dynamic>,
          );
        }

        return isSuccess;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============================
  // UPDATE USER DATA API
  // ============================
  Future<bool> updateUserdata({
    String? userId,
    UserProfile? profile,
    Map<String, dynamic>? extraFields,
  }) async {
    _setLoading(true);

    try {
      final targetUserId = userId;
      if (targetUserId == null || targetUserId.isEmpty) {
        throw ArgumentError('userId or profile.id must be provided');
      }

      final payload = <String, dynamic>{};

      if (profile != null) {
        payload.addAll(profile.toUpdateJson());
      }

      if (extraFields != null && extraFields.isNotEmpty) {
        payload.addAll(extraFields);
      }

      final response = await http.put(
        Uri.parse("${AppConstants.apiUrl}/users/id/$targetUserId"),
        headers: {
          HttpHeaders.contentTypeHeader: AppConstants.applicationJson,
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final bool isSuccess = data["status"] == "success";

        if (isSuccess && data["user"] != null) {
          _userProfile = UserProfile.fromJson(
            data["user"] as Map<String, dynamic>,
          );
        }

        return isSuccess;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============================
  // ✅ WHATSAPP OTP SEND API
  // ============================
  Future<bool> sendWhatsappOtp(String phone) async {
    _setLoading(true);

    try {
      final success = await ApiServices.sendWhatsappOtp(phone);
      return success;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============================
  // ✅ VERIFY WHATSAPP OTP API
  // ============================
  Future<bool> verifyWhatsappOtp({
    required String phone,
    required String otp,
  }) async {
    _setLoading(true);

    try {
      final success = await ApiServices.verifyWhatsappOtp(
        phone: phone,
        otp: otp,
      );
      return success;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ============================
  // ✅ UPDATE PROFILE LOCALLY
  // ============================
  void updateProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }
}
