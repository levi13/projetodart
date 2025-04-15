import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class GraficoPesoScreen extends StatefulWidget {
  const GraficoPesoScreen({super.key});

  @override
  State<GraficoPesoScreen> createState() => _GraficoPesoScreenState();
}

class _GraficoPesoScreenState extends State<GraficoPesoScreen> {
  List<Map<String, dynamic>> _pesos = [];

  @override
  void initState() {
    super.initState();
    _carregarPesos();
  }

  Future<void> _carregarPesos() async {
    final db = await DatabaseHelper().database;
    final pesos = await db.query(
      'pesos',
      where: 'usuario_id = ?',
      whereArgs: [1], // substitua se tiver login
      orderBy: 'data ASC',
    );
    setState(() {
      _pesos = pesos;
    });
  }

  List<FlSpot> _gerarSpots() {
    return List.generate(_pesos.length, (index) {
      final peso = _pesos[index]['peso'] as double;
      return FlSpot(index.toDouble(), peso);
    });
  }

  List<String> _datasFormatadas() {
    return _pesos.map((p) {
      final data = DateTime.parse(p['data']);
      return DateFormat('dd/MM').format(data);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spots = _gerarSpots();
    final datas = _datasFormatadas();

    return Scaffold(
      appBar: AppBar(title: Text('Gráfico de Peso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _pesos.isEmpty
            ? Center(child: Text('Nenhum dado de peso encontrado'))
            : Column(
                children: [
                  Text('Evolução do Peso', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                final i = value.toInt();
                                if (i >= 0 && i < datas.length) {
                                  return Text(datas[i],
                                      style: TextStyle(fontSize: 10));
                                }
                                return Text('');
                              },
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: spots,
                            barWidth: 3,
                            color: Colors.blue,
                            dotData: FlDotData(show: true),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
