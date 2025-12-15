// lib/manualpayment/provider/manual_payment_provider.dart

import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final manualPaymentProvider = ChangeNotifierProvider<ManualPaymentController>((ref) {
  return ManualPaymentController();
});

class ManualPaymentController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
  }

  Future<bool> submitManualPayment(Map<String, dynamic> paymentBody) async {
    clearMessages();
    _setLoading(true);

    try {
      final result = await ApiServices.confirmManualPayment(body: paymentBody);

      if (result != null) {
        if (result["status"] == "success") {
          _successMessage = result["message"] ?? "Payment submitted successfully!";
          notifyListeners();
          return true;
        } else {
          _errorMessage = result["message"] ?? "Submission failed";
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = "No response from server";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
