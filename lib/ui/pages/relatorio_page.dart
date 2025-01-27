import 'package:bricklayer_app/domain/Obras.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RelatorioGastosObra extends StatelessWidget {
  final Obras obra;
  RelatorioGastosObra({required this.obra});

  @override
  Widget build(BuildContext context) {
    final Map<String, double> gastosPorCategoria = {};
    for (var insumo in obra.insumos) {
      if (gastosPorCategoria.containsKey(insumo.nome)) {
        gastosPorCategoria[insumo.nome] = gastosPorCategoria[insumo.nome]! +
            (insumo.valor * insumo.quantidade);
      } else {
        gastosPorCategoria[insumo.nome] = insumo.valor * insumo.quantidade;
      }
    }
    gastosPorCategoria['Mão de Obra'] = obra.valorMaoDeObra ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Gastos da Obra'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gastos por Categoria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final categorias = gastosPorCategoria.keys.toList();
                          if (value.toInt() < categorias.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                categorias[value.toInt()],
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: gastosPorCategoria.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final valor = entry.value.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: valor,
                          color: Colors.orange[800],
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total: R\$ ${gastosPorCategoria.values.reduce((a, b) => a + b).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
