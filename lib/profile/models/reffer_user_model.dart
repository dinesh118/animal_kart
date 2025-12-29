// models/user_model.dart

class RefferalUserResponse {
  final int statuscode;
  final String status;
  final List<RefUsers> refferalUsers;

  RefferalUserResponse({
    required this.statuscode,
    required this.status,
    required this.refferalUsers,
  });

  factory RefferalUserResponse.fromJson(Map<String, dynamic> json) {
    return RefferalUserResponse(
      statuscode: json['statuscode'] ?? 0,
      status: json['status'] ?? '',
      refferalUsers: (json['users'] as List<dynamic>?)
              ?.map((user) => RefUsers.fromJson(user))
              .toList() ??
          [],
    );
  }
}

class RefUsers {
  final String firstName;
  final String lastName;
  final String mobile;
  final String name;

  RefUsers({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.name,
  });

  factory RefUsers.fromJson(Map<String, dynamic> json) {
    return RefUsers(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'mobile': mobile,
      'name': name,
    };
  }

  String get fullName => '$firstName $lastName';
}