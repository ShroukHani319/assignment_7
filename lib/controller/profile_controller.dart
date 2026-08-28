import 'package:hive_flutter/hive_flutter.dart';

class ProfileController {
  final Box profileBox = Hive.box('profile');

  void saveProfile(String name, String? imagePath) {
    profileBox.put('name', name);

    if (imagePath != null) {
      profileBox.put('image', imagePath);
    }
  }
}