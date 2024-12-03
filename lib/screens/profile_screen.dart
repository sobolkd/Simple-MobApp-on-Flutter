import 'package:flutter/material.dart';
import 'package:my_project/database_helper.dart';
import 'package:my_project/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = UserDataProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();  // Повернення на попередній екран
          },
        ),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${user.firstName} ${user.lastName}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showLogOutDialog(context, user.email),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _showLogOutDialog(BuildContext context, String email) async {
    final databaseHelper = DatabaseHelper();

    final bool? shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log Out',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                await databaseHelper.updateUserLoginStatus(email, isLoggedIn:
                 false,);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogOut == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        '/login',
        (Route<dynamic> route) => false,
      );
    }
  }
}
