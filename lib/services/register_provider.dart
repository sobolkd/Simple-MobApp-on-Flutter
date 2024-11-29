import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';

class RegisterProvider extends ChangeNotifier {
  bool _isRegistering = false;

  bool get isRegistering => _isRegistering;

  Future<void> registerUser(
    String email,
    String password,
    String confirmPassword,
    String firstName,
    String lastName,
    BuildContext context,
  ) async {
    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match', context);
      return;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(email)) {
      _showSnackBar('Invalid email format', context);
      return;
    }

    if (firstName.contains(RegExp(r'\d')) || lastName.contains(RegExp(r'\d'))) {
      _showSnackBar('Name cannot contain numbers', context);
      return;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters long', context);
      return;
    }

    final databaseHelper = DatabaseHelper();

    final exists = await databaseHelper.checkIfUserExists(email);
    if (exists) {
      // ignore: use_build_context_synchronously
      _showSnackBar('Email is already registered', context);
      return;
    }

    final newUser = {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    };

    try {
      _isRegistering = true;
      notifyListeners();
      await databaseHelper.insertUser(newUser);
      // ignore: use_build_context_synchronously
      _showSnackBar('User registered successfully', context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnackBar('Error: $e', context);
    } finally {
      _isRegistering = false;
      notifyListeners();
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
      Text(message),),);
    }
  }
}
