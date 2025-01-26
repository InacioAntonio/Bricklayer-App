import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:intl/intl.dart';

class Obras {
  late String nome;
  late DateTime dataInicio; // Usando DateTime
  late DateTime dataFim;
  late String descricao;
  double qtdInsumos = 0;
  List<Insumos> insumos = [];
  List<Tarefa>? tarefas = [];
  double valorTotal = 0;
  double valorMaoDeObra = 0;
  Obras({
    required this.nome,
    required this.dataInicio,
    required this.dataFim,
    required this.insumos,
    required this.valorTotal,
    required this.descricao,
    required this.valorMaoDeObra,
    this.tarefas,
  });
  // Método para formatar a data de início como string
  String get dataInicioFormatada {
    return DateFormat('dd/MM/yyyy').format(dataInicio);
  }

  // Método para formatar a data de fim como string
  String get dataFimFormatada {
    return DateFormat('dd/MM/yyyy').format(dataFim);
  }

  // Método para mapear o objeto Obra para Map
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'dataInicio': dataInicio.toIso8601String(), // Salva em formato ISO 8601
      'dataFim': dataFim.toIso8601String(),
      'descricao': descricao,
      'valorTotal': valorTotal,
      'Lista_insumos': insumos.map((insumo) {
        return {
          'nome': insumo.nome,
          'valor': insumo.valor,
          'quantidade': insumo.quantidade,
        };
      }).toList(),
      'tarefas': tarefas?.map((tarefa) {
        return tarefa.toMap();
      }).toList(),
    };
  }
}
