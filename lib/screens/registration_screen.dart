import 'package:flutter/material.dart';
import 'package:my_project/widgets/button.dart'; 
import 'package:my_project/widgets/field_info.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController=TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  RegisterScreen({super.key});

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
              onPressed: () {
                // Register logic
              },
            ),
            TextButton(
              onPressed: () {
                // Go to the login
                Navigator.pop(context);
              },
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
