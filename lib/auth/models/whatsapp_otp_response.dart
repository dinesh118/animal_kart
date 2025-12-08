class WhatsappOtpResponse {
  final int statuscode;
  final String status;
  final String message;

  WhatsappOtpResponse({
    required this.statuscode,
    required this.status,
    required this.message,
  });

  factory WhatsappOtpResponse.fromJson(Map<String, dynamic> json) {
    return WhatsappOtpResponse(
      statuscode: json['statuscode'],
      status: json['status'],
      message: json['message'],
    );
  }
}
