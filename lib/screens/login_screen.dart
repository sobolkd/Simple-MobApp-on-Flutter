import 'package:flutter/material.dart';
import 'package:my_project/network_utils.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/registration_screen.dart';
import 'package:my_project/services/auth_provider.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/field_info.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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
              onPressed: () => _handleLoginPressed(context, emailController,
               passwordController, authProvider,),
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
  
  void _handleLoginPressed(BuildContext context,
   TextEditingController emailController, TextEditingController
    passwordController, AuthProvider authProvider,) async {
    final email = emailController.text;
    final password = passwordController.text;

    final bool isConnected = await checkConnectivity();
    if (!isConnected) {
      // ignore: use_build_context_synchronously
      _showNoConnectionDialog(context);
    } else {
      if (email.isNotEmpty && password.isNotEmpty) {
        await authProvider.login(email, password);
        if (authProvider.isLoggedIn) {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // ignore: use_build_context_synchronously
          _showSnackBar(context, 'Invalid email or password.');
        }
      } else {
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'Please fill in both fields.');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: 
    Text(message),),);
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
}
