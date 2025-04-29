import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class RefeicoesScreen extends StatefulWidget {
  const RefeicoesScreen({super.key, required Map<String, dynamic> refeicao});

  @override
  State<RefeicoesScreen> createState() => _RefeicoesScreenState();
}

class _RefeicoesScreenState extends State<RefeicoesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Map<String, dynamic>> _refeicoes = [];

  @override
  void initState() {
    super.initState();
    _carregarRefeicoes();
  }

  // Função para carregar as refeições do banco de dados
  Future<void> _carregarRefeicoes() async {
  final refeicoes = await DatabaseHelper().getRefeicoes();
  setState(() {
    _refeicoes = refeicoes;
  });
}


  // Função para adicionar uma refeição ao banco de dados
  Future<void> _adicionarRefeicao() async {
  if (_formKey.currentState!.validate()) {
    print('Formulário válido');
    final titulo = _tituloController.text;
    final descricao = _descricaoController.text;

    try {
      final db = await DatabaseHelper().database;
      await db.insert('refeicoes', {
        'titulo': titulo,
        'descricao': descricao,
        'data': DateTime.now().toString(),
      });
      print('Refeição adicionada ao banco');
    } catch (e) {
      print('Erro ao adicionar refeição: $e');
    }

    _tituloController.clear();
    _descricaoController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Refeição adicionada com sucesso!')),
    );

    _carregarRefeicoes();  // Atualizar a lista
  } else {
    print('Formulário inválido');
  }
}

  // Função para excluir uma refeição
  Future<void> _excluirRefeicao(int id) async {
  await DatabaseHelper().deleteRefeicao(id);
  _carregarRefeicoes();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciar Refeições')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Formulário para adicionar uma refeição
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(labelText: 'Título da Refeição'),
                    validator: (val) =>
                        val!.isEmpty ? 'Informe o título da refeição' : null,
                  ),
                  TextFormField(
                    controller: _descricaoController,
                    decoration:
                        InputDecoration(labelText: 'Descrição da Refeição'),
                    validator: (val) =>
                        val!.isEmpty ? 'Informe a descrição da refeição' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Botão pressionado');
                      _adicionarRefeicao();
                    },
                    child: Text('Adicionar Refeição'),
                  ),

                ],
              ),
            ),
            SizedBox(height: 20),
            // Exibição da lista de refeições
            Expanded(
              child: _refeicoes.isEmpty
                  ? Center(child: Text('Nenhuma refeição cadastrada.'))
                  : ListView.builder(
                      itemCount: _refeicoes.length,
                      itemBuilder: (context, index) {
                        final refeicao = _refeicoes[index];
                        return ListTile(
                          title: Text(refeicao['titulo']),
                          subtitle: Text(refeicao['descricao']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _excluirRefeicao(refeicao['id']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
