import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _username = 'guest';

  String get username => _username;

  UserProvider() {
    _loadUsername();
  }

  void setUsername(String newUsername) async {
    _username = newUsername;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', newUsername);
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'guest';
    notifyListeners();
  }
}
