import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  final Box<User> _userBox = Hive.box<User>('users');
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> register(
      String name, String email, String password, bool isAdmin) async {
    final user =
        User(name: name, email: email, password: password, isAdmin: isAdmin);
    await _userBox.put(email, user);
  }

  Future<void> login(String email, String password) async {
    final user = _userBox.get(email);
    if (user != null && user.password == password) {
      _user = user;
      notifyListeners();
    } else {
      // Handle error: user not found or wrong password
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
