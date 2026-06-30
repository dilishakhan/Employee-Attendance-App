import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/profile_service.dart';

final profileServiceProvider = Provider((ref) {
  return ProfileService();
});

final profileProvider = FutureProvider<UserModel>((ref) async {
  return ref.read(profileServiceProvider).getCurrentUser();
});
