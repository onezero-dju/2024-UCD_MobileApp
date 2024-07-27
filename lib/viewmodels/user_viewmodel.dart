import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> fetchUser(String id) async {
    _user = await ApiService.getUser(id);
    notifyListeners();
  }
}
