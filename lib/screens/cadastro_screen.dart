import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nome = '';
  String _email = '';
  String _senha = '';

  Future<void> _cadastrar() async {
    final db = await DatabaseHelper().database;

    // Verifica se o e-mail já existe
    final existing = await db.query(
      'administradores',
      where: 'email = ?',
      whereArgs: [_email],
    );

    if (existing.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail já cadastrado!')),
      );
      return;
    }

    // Insere novo administrador
    await db.insert('administradores', {
      'nome': _nome,
      'email': _email,
      'senha': _senha,
    });

    // Confirmação de cadastro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );

    // Aguarda 2 segundos e volta para a tela de login
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context); // Volta para a tela de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (val) => val!.isEmpty ? 'Informe seu nome' : null,
                onSaved: (val) => _nome = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Informe seu e-mail' : null,
                onSaved: (val) => _email = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Informe sua senha' : null,
                onSaved: (val) => _senha = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _cadastrar();
                  }
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
