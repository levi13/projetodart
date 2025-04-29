import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _senha = '';
  bool _isLogin = true;

  Future<void> _autenticarOuCadastrar() async {
    final db = await DatabaseHelper().database;

    if (_isLogin) {
      final result = await db.query(
        'administradores',
        where: 'email = ? AND senha = ?',
        whereArgs: [_email, _senha],
      );

      if (result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!')),
        );
        // Após o login, abre o menu (Drawer)
        _openDrawer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-mail ou senha incorretos')),
        );
      }
    } else {
      await db.insert('administradores', {
        'nome': 'Admin', // Ou adicione campo nome no form se quiser
        'email': _email,
        'senha': _senha,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Administrador cadastrado com sucesso!')),
      );

      setState(() {
        _isLogin = true;
      });
    }
  }

  // Função para abrir o Drawer
  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Cadastro'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text('App Saúde'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: const Text('IMC'),
              onTap: () {
                Navigator.pushNamed(context, '/imc');
              },
            ),
            ListTile(
              title: const Text('Cadastrar Administrador'),
              onTap: () {
                Navigator.pushNamed(context, '/cadastro');
              },
            ),
             ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Refeições'),
              onTap: () {
                Navigator.pushNamed(context, '/refeicoes');
              },
            ),ListTile(
                leading: const Icon(Icons.fitness_center),
                title: const Text('Atividades Físicas'),
                onTap: () {
                  Navigator.pushNamed(context, '/atividades');
                },
            ),

            // Adicione mais itens de navegação aqui
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val!.isEmpty ? 'Informe seu e-mail' : null,
                onSaved: (val) => _email = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (val) =>
                    val!.isEmpty ? 'Informe sua senha' : null,
                onSaved: (val) => _senha = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _autenticarOuCadastrar();
                  }
                },
                child: Text(_isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin
                    ? 'Não tem conta? Cadastre-se'
                    : 'Já tem conta? Entrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
