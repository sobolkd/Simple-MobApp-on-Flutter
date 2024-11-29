import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/network_utils.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/registration_screen.dart';
import 'package:my_project/services/autologin_service.dart';
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
              onPressed: () => _handleLoginPressed(context),
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

  void _handleLoginPressed(BuildContext context) async {
  final bool isConnected = await checkConnectivity();

  if (!isConnected) {
    if (mounted) {
      // ignore: use_build_context_synchronously
      await _showNoConnectionDialog(context);
    }
  } else {
    if (mounted) {
      // ignore: use_build_context_synchronously
      await _loginUser(context);
    }
  }
}


  Future<void> _loginUser(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Please fill in both fields.');
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
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute<Widget>(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      _showSnackBar(context, 'Invalid email or password.');
    }
  }

  Future<void> _checkAutoLogin() async {
    final autoLoginService = AutoLoginService();
    final currentUser = await autoLoginService.checkAutoLogin();

    if (currentUser != null && mounted) {
      _showSnackBar(context,
       'Welcome back, ${currentUser.firstName} ${currentUser.lastName}!',);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<Widget>(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _showNoConnectionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('No Connection', style: TextStyle(color:
         Colors.black,),),
        content: const Text(
          'Please connect to the internet. Limited app functionality.',
          style: TextStyle(color: Colors.black),
        ),
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

  void _showSnackBar(BuildContext context, String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
      Text(message),),);
    }
  }
}
