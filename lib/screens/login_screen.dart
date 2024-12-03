import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/network_utils.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/registration_screen.dart';
import 'package:my_project/user.dart';
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
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

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
    final bool isConnected = await checkConnectivity();
    if (!isConnected) {
      // ignore: use_build_context_synchronously
      await _showNoConnectionDialog(context);
    } else {
      await _loginUser();
    }
  }

  Future<void> _loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in both fields.');
      return;
    }

    final databaseHelper = DatabaseHelper();

    final exists = await databaseHelper.checkLogin(email, password);

    if (exists) {
      final user = await databaseHelper.getUserByEmail(email);

      if (user != null) {
        final firstName = user['first_name'] as String;
        final lastName = user['last_name'] as String;
        final email = user['email'] as String;

        UserDataProvider.currentUser = User(
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        await databaseHelper.updateUserLoginStatus(email, isLoggedIn: true);
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

  Future<void> _checkAutoLogin() async {
    final bool isConnected = await checkConnectivity();
    
    final databaseHelper = DatabaseHelper();
    final users = await databaseHelper.getUsers();

    for (var user in users) {
      if (user['is_logged_in'] == 1) {
        final firstName = user['first_name'] as String;
        final lastName = user['last_name'] as String;
        final email = user['email'] as String;

        UserDataProvider.currentUser = User(
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        if (!isConnected) {
          // ignore: use_build_context_synchronously
          await _showNoConnectionDialog(context);
        }

        if (mounted) {
          _showSnackBar('Welcome back, $firstName $lastName!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<Widget>(builder: (context) => const HomeScreen()),
          );
        }

        break;
      }
    }
  }

  Future<void> _showNoConnectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Відсутнє з\'єднання', style: TextStyle(color:
         Colors.black,),),
content:
const 
Text('Будь ласка, підключіться до Інтернету. Користування додатком обмежене', 
        style: TextStyle(color: Colors.black,),),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
