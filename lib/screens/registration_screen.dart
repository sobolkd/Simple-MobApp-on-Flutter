import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/widgets/button.dart'; 
import 'package:my_project/widgets/field_info.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FieldInfo(
              hintText: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 16),
            FieldInfo(
              hintText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            FieldInfo(
              hintText: 'Repeat Password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            FieldInfo(
              hintText: 'First Name',
              controller: firstNameController,
            ),
            const SizedBox(height: 16),
            FieldInfo(
              hintText: 'Last Name',
              controller: lastNameController,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Register',
              onPressed: registerUser,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser() async {
  if (passwordController.text != confirmPasswordController.text) {
    showSnackBar('Passwords do not match');
    return;
  }

  final email = emailController.text;
  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(email)) {
    showSnackBar('Invalid email format');
    return;
  }

  if (firstNameController.text.contains(RegExp(r'\d')) || lastNameController.text.contains(RegExp(r'\d'))) {
    showSnackBar('Name cannot contain numbers');
    return;
  }

  if (passwordController.text.length < 6) {
    showSnackBar('Password must be at least 6 characters long');
    return;
  }

  // Створюємо екземпляр DatabaseHelper
  final databaseHelper = DatabaseHelper();

  final exists = await databaseHelper.checkIfUserExists(emailController.text);
  if (exists) {
    showSnackBar('Email is already registered');
    return;
  }

  final newUser = {
    'email': email,
    'password': passwordController.text,
    'first_name': firstNameController.text,
    'last_name': lastNameController.text,
  };

  try {
    await databaseHelper.insertUser(newUser);
    showSnackBar('User registered successfully');
    navigateBack();
  } catch (e) {
    showSnackBar('Error: $e');
  }
}


  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
       Text(message),),);
    }
  }

  void navigateBack() {
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
