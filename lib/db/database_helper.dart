import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("app_saude.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE administradores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL,
        senha TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE pesos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER,
        peso REAL,
        data TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE refeicoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        data TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE exercicios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE notas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        conteudo TEXT,
        data TEXT
      );
    ''');
  }

  // ===============================
  // CRUD - ADMINISTRADORES
  // ===============================
  Future<int> addAdministrador(String nome, String email, String senha) async {
    final db = await database;
    return await db.insert('administradores', {
      'nome': nome,
      'email': email,
      'senha': senha,
    });
  }

  Future<List<Map<String, dynamic>>> getAdministradores() async {
    final db = await database;
    return await db.query('administradores');
  }

  Future<int> updateAdministrador(int id, String nome, String email, String senha) async {
    final db = await database;
    return await db.update(
      'administradores',
      {'nome': nome, 'email': email, 'senha': senha},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAdministrador(int id) async {
    final db = await database;
    return await db.delete('administradores', where: 'id = ?', whereArgs: [id]);
  }

  // ===============================
  // CRUD - PESOS
  // ===============================
  Future<int> addPeso(int usuarioId, double peso, String data) async {
    final db = await database;
    return await db.insert('pesos', {
      'usuario_id': usuarioId,
      'peso': peso,
      'data': data,
    });
  }

  Future<List<Map<String, dynamic>>> getPesos() async {
    final db = await database;
    return await db.query('pesos', orderBy: 'data DESC');
  }

  Future<int> updatePeso(int id, double peso, String data) async {
    final db = await database;
    return await db.update(
      'pesos',
      {'peso': peso, 'data': data},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePeso(int id) async {
    final db = await database;
    return await db.delete('pesos', where: 'id = ?', whereArgs: [id]);
  }

  // ===============================
  // CRUD - REFEIÇÕES
  // ===============================
  Future<int> addRefeicao(String titulo, String descricao, String data) async {
    final db = await database;
    return await db.insert('refeicoes', {
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    });
  }

  Future<List<Map<String, dynamic>>> getRefeicoes() async {
    final db = await database;
    return await db.query('refeicoes', orderBy: 'data DESC');
  }

  Future<int> updateRefeicao(int id, String titulo, String descricao, String data) async {
    final db = await database;
    return await db.update(
      'refeicoes',
      {'titulo': titulo, 'descricao': descricao, 'data': data},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRefeicao(int id) async {
    final db = await database;
    return await db.delete('refeicoes', where: 'id = ?', whereArgs: [id]);
  }

  // ===============================
  // CRUD - EXERCÍCIOS
  // ===============================
  Future<int> addExercicio(String nome, String descricao) async {
    final db = await database;
    return await db.insert('exercicios', {
      'nome': nome,
      'descricao': descricao,
    });
  }

  Future<List<Map<String, dynamic>>> getExercicios() async {
    final db = await database;
    return await db.query('exercicios');
  }

  Future<int> updateExercicio(int id, String nome, String descricao) async {
    final db = await database;
    return await db.update(
      'exercicios',
      {'nome': nome, 'descricao': descricao},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExercicio(int id) async {
    final db = await database;
    return await db.delete('exercicios', where: 'id = ?', whereArgs: [id]);
  }

  // ===============================
  // CRUD - NOTAS
  // ===============================
  Future<int> addNota(String titulo, String conteudo, String data) async {
    final db = await database;
    return await db.insert('notas', {
      'titulo': titulo,
      'conteudo': conteudo,
      'data': data,
    });
  }

  Future<List<Map<String, dynamic>>> getNotas() async {
    final db = await database;
    return await db.query('notas', orderBy: 'data DESC');
  }

  Future<int> updateNota(int id, String titulo, String conteudo, String data) async {
    final db = await database;
    return await db.update(
      'notas',
      {
        'titulo': titulo,
        'conteudo': conteudo,
        'data': data,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNota(int id) async {
    final db = await database;
    return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
  }
}
