import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/registration_screen.dart';
import 'package:my_project/user.dart'; // Імпортуємо модель User
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/field_info.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
            CustomButton(
              text: 'Login',
              onPressed: _handleLoginPressed,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Don’t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLoginPressed() async {
    await _loginUser();
  }

  Future<void> _loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in both fields.');
      return;
    }

    final exists = await DatabaseHelper.checkLogin(email, password);

    if (exists) {
      // Отримуємо дані користувача з бази
      final user = await DatabaseHelper.getUserByEmail(email);

      if (user != null) {
        // Переконуємося, що значення є рядком
        final firstName = user['first_name'] as String;
        final lastName = user['last_name'] as String;
        final userEmail = user['email'] as String;

        // Зберігаємо поточного користувача
        UserDataProvider.currentUser = User(
          firstName: firstName,
          lastName: lastName,
          email: userEmail,
        );
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<Widget>(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } else {
      _showSnackBar('Invalid email or password.');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
