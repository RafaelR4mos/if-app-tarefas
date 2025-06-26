import 'package:flutter/material.dart';
import 'package:todoappv2/screens/login.dart';
import 'package:todoappv2/screens/cadastro.dart';
import 'package:todoappv2/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
      },
    );
  }
}
