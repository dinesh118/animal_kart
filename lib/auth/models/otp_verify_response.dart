class OtpVerifyResponse {
  final int statuscode;
  final String status;
  final String message;
  final dynamic user;

  OtpVerifyResponse({
    required this.statuscode,
    required this.status,
    required this.message,
    this.user,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      statuscode: json['statuscode'],
      status: json['status'],
      message: json['message'],
      user: json['user'],
    );
  }
}
