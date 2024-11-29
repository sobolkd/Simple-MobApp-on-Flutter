import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/user.dart';
import 'package:my_project/user_data_provider.dart' as udp;

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;

  final DatabaseHelper databaseHelper = DatabaseHelper();

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    final exists = await databaseHelper.checkLogin(email, password);

    if (exists) {
      final user = await databaseHelper.getUserByEmail(email);
      if (user != null) {
        _currentUser = User(
          firstName: user['first_name'] as String,
          lastName: user['last_name'] as String,
          email: user['email'] as String,
        );
        _isLoggedIn = true;

        // save in UserDataProvider
        udp.UserDataProvider.currentUser = _currentUser;

        await databaseHelper.updateUserLoginStatus(email, isLoggedIn: true);
        notifyListeners();
      }
    }
  }

  Future<User?> checkAutoLogin() async {
    final users = await databaseHelper.getUsers();

    for (var user in users) {
      if (user['is_logged_in'] == 1) {
        final firstName = user['first_name'] as String;
        final lastName = user['last_name'] as String;
        final email = user['email'] as String;

         // save in UserDataProvider
        udp.UserDataProvider.currentUser = User(
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        _currentUser = udp.UserDataProvider.currentUser;
        _isLoggedIn = true;

        notifyListeners();
        return _currentUser;
      }
    }

    return null;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    udp.UserDataProvider.currentUser = null;
    await databaseHelper.updateUserLoginStatus(_currentUser?.email ?? '',
     isLoggedIn: false,);
    notifyListeners();
  }
}
