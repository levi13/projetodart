import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final _formKey = GlobalKey<FormState>();
  double? _peso;
  double? _alturaCm; // A altura será fornecida em centímetros.
  double? _imc;
  String _classificacao = '';
  String _recomendacao = ''; // Para armazenar a recomendação alimentar
  String _dieta = ''; // Para armazenar a recomendação de dieta
  String _atividadeFisica = ''; // Para armazenar a recomendação de atividade física

  void _calcularIMC() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Converte a altura de centímetros para metros
      double alturaMetros = _alturaCm! / 100;

      // Cálculo do IMC
      final imc = _peso! / (alturaMetros * alturaMetros);
      String classificacao;
      String recomendacao;
      String dieta;
      String atividadeFisica;

      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
        recomendacao = 'É importante consumir alimentos ricos em calorias e nutrientes, como grãos, proteínas e gorduras saudáveis.';
        dieta = 'Inclua alimentos como abacate, azeite de oliva, nozes, queijos integrais e carnes magras. Faça refeições frequentes e equilibradas.';
        atividadeFisica = 'Aconselha-se a prática de musculação para ganho de massa muscular e caminhada leve para melhorar o condicionamento físico.';
      } else if (imc < 24.9) {
        classificacao = 'Peso ideal';
        recomendacao = 'Mantenha uma alimentação equilibrada com a combinação de carboidratos, proteínas e gorduras saudáveis.';
        dieta = 'Mantenha uma dieta balanceada, incluindo frutas, vegetais, proteínas magras, grãos integrais e gorduras boas, como azeite de oliva.';
        atividadeFisica = 'Atividades como corrida moderada, ciclismo, natação ou musculação para manter a forma física.';
      } else if (imc < 29.9) {
        classificacao = 'Sobrepeso';
        recomendacao = 'Para perder peso, consuma alimentos com baixo teor calórico e pratique exercícios físicos regularmente. Evite alimentos processados e ricos em açúcares.';
        dieta = 'Evite alimentos com alto teor de açúcar e gorduras saturadas. Foque em proteínas magras, vegetais e carboidratos de baixo índice glicêmico. Tente manter um déficit calórico para emagrecer gradualmente.';
        atividadeFisica = 'Recomenda-se atividades como caminhada rápida, natação ou ciclismo. Também pode ser interessante experimentar HIIT (treinamento intervalado de alta intensidade) para queima de gordura.';
      } else {
        classificacao = 'Obesidade';
        recomendacao = 'É recomendado reduzir o consumo de calorias, focando em alimentos com baixo teor calórico e fazer atividades físicas para ajudar na perda de peso.';
        dieta = 'Consuma principalmente vegetais, proteínas magras e alimentos com baixo índice glicêmico, como legumes e grãos integrais. Evite alimentos processados e bebidas açucaradas.';
        atividadeFisica = 'Recomenda-se atividades de baixo impacto, como caminhada, hidroginástica ou natação, para queimar calorias sem sobrecarregar as articulações.';
      }

      setState(() {
        _imc = imc;
        _classificacao = classificacao;
        _recomendacao = recomendacao; // Atualiza a recomendação
        _dieta = dieta; // Atualiza a recomendação de dieta
        _atividadeFisica = atividadeFisica; // Atualiza a recomendação de atividade física
      });

      // Salva o peso no banco de dados
      final db = await DatabaseHelper().database;
      await db.insert('pesos', {
        'usuario_id': 1, // Ajustar com autenticação, se necessário
        'peso': _peso,
        'data': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Peso registrado com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cálculo de IMC')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo para o peso
              TextFormField(
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? 'Informe seu peso' : null,
                onSaved: (val) => _peso = double.parse(val!),
              ),
              // Campo para a altura em centímetros
              TextFormField(
                decoration: InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? 'Informe sua altura' : null,
                onSaved: (val) => _alturaCm = double.parse(val!),
              ),
              SizedBox(height: 20),
              // Botão para calcular o IMC
              ElevatedButton(
                onPressed: _calcularIMC,
                child: Text('Calcular IMC'),
              ),
              SizedBox(height: 20),
              // Exibe o IMC, a classificação, a recomendação, a dieta e a atividade física
              if (_imc != null)
                Column(
                  children: [
                    Text('IMC: ${_imc!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18)),
                    Text('Classificação: $_classificacao',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Recomendação Alimentar:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(_recomendacao,
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Dieta Recomendada:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(_dieta,
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Atividade Física Recomendada:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(_atividadeFisica,
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
