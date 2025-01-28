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

    final List<Color> coresDasBarras = [
      Colors.orange[800]!,
      Colors.blue[800]!,
      Colors.green[800]!,
      Colors.red[800]!,
      Colors.purple[800]!,
      Colors.teal[800]!,
    ];

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
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'R\$ ${value.toInt()}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
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
                          color: coresDasBarras[index % coresDasBarras.length],
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      showingTooltipIndicators: [0], // Mostrar tooltip
                    );
                  }).toList(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.black87,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final categoria =
                            gastosPorCategoria.keys.toList()[group.x.toInt()];
                        final valor = rod.toY;
                        return BarTooltipItem(
                          '$categoria\nR\$ ${valor.toStringAsFixed(2)}',
                          TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
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
