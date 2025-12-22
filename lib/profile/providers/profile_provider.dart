

import 'package:animal_kart_demo2/auth/models/user_model.dart';
import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>(
  (ref) => ProfileNotifier(ref),
);

class ProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  ProfileNotifier(this.ref) : super(const AsyncLoading());

  Future<void> loadProfile() async {
    state = const AsyncLoading();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userMobile');
      final user = await ApiServices.fetchUserProfile(userId!);
      state = AsyncData(user);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
