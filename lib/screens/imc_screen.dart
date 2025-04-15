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
  double? _altura;
  double? _imc;
  String _classificacao = '';

  void _calcularIMC() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final imc = _peso! / (_altura! * _altura!);
      String classificacao;

      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
      } else if (imc < 24.9) {
        classificacao = 'Peso ideal';
      } else if (imc < 29.9) {
        classificacao = 'Sobrepeso';
      } else {
        classificacao = 'Obesidade';
      }

      setState(() {
        _imc = imc;
        _classificacao = classificacao;
      });

      final db = await DatabaseHelper().database;
      await db.insert('pesos', {
        'usuario_id': 1, // por enquanto fixo, depois ajusta com autenticação
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? 'Informe seu peso' : null,
                onSaved: (val) => _peso = double.parse(val!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Altura (m)'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? 'Informe sua altura' : null,
                onSaved: (val) => _altura = double.parse(val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularIMC,
                child: Text('Calcular IMC'),
              ),
              SizedBox(height: 20),
              if (_imc != null)
                Column(
                  children: [
                    Text('IMC: ${_imc!.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18)),
                    Text('Classificação: $_classificacao',
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
