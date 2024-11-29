import 'package:flutter/material.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/services/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D&D Character Creator',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF00171F),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFFFFFFF),
          onPrimary: Colors.white,
          secondary: const Color(0xFFFFFFFF),
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      // Завантажуємо стан користувача перед побудовою екрану
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context,
         listen: false,).checkAutoLogin(),
        builder: (context, snapshot) {
          // Якщо статус завантажується, показуємо індикатор завантаження
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          // Якщо користувач авторизований, переходимо на головну сторінку
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          }
          
          // Якщо немає авторизованого користувача, переходимо на екран входу
          return const LoginScreen();
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
