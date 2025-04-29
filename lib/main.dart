import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/imc_screen.dart';
import 'screens/refeicoes_screen.dart';  
import 'screens/atividades_screen.dart';


void main() {
  runApp(const AppSaude());
}

class AppSaude extends StatelessWidget {
  const AppSaude({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Saúde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/imc': (context) => const ImcScreen(),
        '/refeicoes': (context) => const RefeicoesScreen(refeicao: {},), // Rota para a tela de refeições
        '/atividades': (context) => const AtividadesScreen(),
      },
    );
  }
}
