import 'package:animal_kart_demo2/auth/models/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final userProfileProvider = ChangeNotifierProvider<UserProfileNotifier>(
  (ref) => UserProfileNotifier(),
);

class UserProfileNotifier extends ChangeNotifier {
  // void saveProfile(UserProfile profile) {
  //   state = profile;
  // }

  // void logout() {
  //   state = null;
  // }
}
