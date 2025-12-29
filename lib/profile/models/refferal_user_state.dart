import 'package:animal_kart_demo2/profile/models/reffer_user_model.dart';

class RefferalUserState {
  final bool isLoading;
  final String? error;
  final RefferalUserResponse? userResponse;

  RefferalUserState({
    this.isLoading = false,
    this.error,
    this.userResponse,
  });

  RefferalUserState copyWith({
    bool? isLoading,
    String? error,
    RefferalUserResponse? userResponse,
  }) {
    return RefferalUserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? (error == null ? this.error : error),
      userResponse: userResponse ?? this.userResponse,
    );
  }
}