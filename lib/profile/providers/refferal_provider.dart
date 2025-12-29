import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:animal_kart_demo2/profile/models/refferal_user_state.dart';

import 'package:flutter_riverpod/legacy.dart';

final refferalUserProvider = StateNotifierProvider<RefferalUserNotifier, RefferalUserState>(
  (ref) => RefferalUserNotifier(),
);

class RefferalUserNotifier extends StateNotifier<RefferalUserState> {
  RefferalUserNotifier() : super(RefferalUserState());

  // This will always fetch fresh data for the given mobile
  Future<void> fetchUsersByMobile(String mobile) async {
    // Optional: Prevent duplicate concurrent calls for same mobile
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      userResponse: null, // Clear previous data
    );

    try {
      final response = await ApiServices.fetchUserByMobile(mobile);

      if (response != null && response.refferalUsers.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          userResponse: response,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          userResponse: null,
          error: 'No referred users found for this mobile number.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        userResponse: null,
        error: 'Failed to load users: ${e.toString()}',
      );
    }
  }

  void clear() {
    state = RefferalUserState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}