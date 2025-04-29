import 'package:flutter/material.dart';

class AtividadesScreen extends StatelessWidget {
  const AtividadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aqui você pode futuramente carregar sugestões específicas de acordo com o IMC
    return Scaffold(
      appBar: AppBar(title: const Text('Sugestões de Atividades Físicas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Sugestões Gerais:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('• Caminhadas diárias de 30 minutos'),
          Text('• Hidroginástica para baixo impacto nas articulações'),
          Text('• Academia com acompanhamento profissional'),
          Text('• Natação 2 a 3x por semana'),
          Text('• Yoga ou Pilates para flexibilidade e controle corporal'),
          // Você pode adaptar dinamicamente conforme o IMC futuramente
        ],
      ),
    );
  }
}
