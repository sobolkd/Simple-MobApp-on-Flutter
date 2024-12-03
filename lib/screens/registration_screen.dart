import 'package:flutter/material.dart';
import 'package:my_project/services/register_provider.dart';
import 'package:my_project/widgets/button.dart';
import 'package:my_project/widgets/field_info.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<RegisterProvider>(
          builder: (context, registerProvider, child) {
            return Column(
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
                  text: registerProvider.isRegistering ? 'Registering...' : 
                  'Register',
                  onPressed: registerProvider.isRegistering
                      ? () {}
                      : () {
                          registerProvider.registerUser(
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                            firstNameController.text,
                            lastNameController.text,
                            context,
                          );
                        },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
