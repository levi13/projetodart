import 'package:flutter/material.dart';
import 'imc_screen.dart';
import 'grafico_peso_screen.dart';
// Importe outras telas aqui

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCard(
            context,
            icon: Icons.monitor_weight,
            label: 'IMC',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ImcScreen()),
            ),
          ),
          _buildCard(
            context,
            icon: Icons.show_chart,
            label: 'Gráfico Peso',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GraficoPesoScreen()),
            ),
          ),
          _buildCard(
            context,
            icon: Icons.question_answer,
            label: 'Objetivo',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionarioScreen()));
            },
          ),
          _buildCard(
            context,
            icon: Icons.restaurant,
            label: 'Refeições',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => RefeicoesScreen()));
            },
          ),
          _buildCard(
            context,
            icon: Icons.fitness_center,
            label: 'Exercícios',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciciosScreen()));
            },
          ),
          _buildCard(
            context,
            icon: Icons.note,
            label: 'Notas',
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => NotasScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
