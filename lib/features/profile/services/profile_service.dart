import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserModel> getCurrentUser() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await _client
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    return UserModel.fromJson(response);
  }
}
