class AuthState {
  final String phoneNumber;
  final bool otpSent;
  final bool isVerified;
  final String error;
  final bool isLoading;

  AuthState({
    this.phoneNumber = "",
    this.otpSent = false,
    this.isVerified = false,
    this.error = "",
    this.isLoading = false,
  });

  AuthState copyWith({
    String? phoneNumber,
    bool? otpSent,
    bool? isVerified,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpSent: otpSent ?? this.otpSent,
      isVerified: isVerified ?? this.isVerified,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
