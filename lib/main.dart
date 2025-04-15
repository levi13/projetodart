import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/imc_screen.dart';
// Adicione outras telas conforme forem sendo criadas

void main() {
  runApp(AppSaude());
}

class AppSaude extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Saúde',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/imc': (context) => ImcScreen(),
        // Adicione mais rotas aqui
      },
    );
  }
}
