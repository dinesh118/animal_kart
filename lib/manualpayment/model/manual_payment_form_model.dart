// lib/manualpayment/models/manual_payment_form_model.dart
class BankTransferFormData {
  final String amount;
  final String utrNumber;
  final String bankName;
  final String ifscCode;
  final String transactionDate;
  final String transferMode;
  final String? screenshotUrl;
  final String? screenshotPath;
  
  BankTransferFormData({
    required this.amount,
    required this.utrNumber,
    required this.bankName,
    required this.ifscCode,
    required this.transactionDate,
    required this.transferMode,
    this.screenshotUrl,
    this.screenshotPath,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'transferMode': transferMode,
      'amount': double.parse(amount),
      'utrNumber': utrNumber,
      'payerBankName': bankName,
      'transactionDate': transactionDate,
      'payerIFSC': ifscCode,
      'paymentScreenshotUrl': screenshotUrl,
    };
  }
}

class ChequePaymentFormData {
  final String chequeNumber;
  final String chequeDate;
  final String amount;
  final String bankName;
  final String ifscCode;
  final String utrReference;
  final String? frontImageUrl;
  final String? backImageUrl;
  final String? frontImagePath;
  final String? backImagePath;
  
  ChequePaymentFormData({
    required this.chequeNumber,
    required this.chequeDate,
    required this.amount,
    required this.bankName,
    required this.ifscCode,
    required this.utrReference,
    this.frontImageUrl,
    this.backImageUrl,
    this.frontImagePath,
    this.backImagePath,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'chequeNumber': chequeNumber,
      'chequeDate': chequeDate,
      'amount': double.parse(amount),
      'bankName': bankName,
      'ifscCode': ifscCode,
      'utrReference': utrReference,
      'chequeFrontImage': frontImageUrl,
      'chequeBackImage': backImageUrl,
    };
  }
}