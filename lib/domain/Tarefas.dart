import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:intl/intl.dart';

class Tarefa {
  late String nome;
  late String descricao;
  late DateTime dataInicio; // Usando DateTime
  late DateTime dataFim; // Usando DateTime
  late bool concluido;
  late List<Insumos> insumos;
  late String
      obra; // Toda tarefa está associada a somente uma Obra mas a Obra pode ter Uma lista de Tarefas
  Tarefa({
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.insumos,
    required this.obra,
    this.concluido = false,
  });
  // Método para formatar a data de início como string
  String get dataInicioFormatada {
    return DateFormat('dd/MM/yyyy').format(dataInicio);
  }

  // Método para formatar a data de fim como string
  String get dataFimFormatada {
    return DateFormat('dd/MM/yyyy').format(dataFim);
  }

  // Converter a tarefa para mapa (para armazenamento)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'dataInicio': dataInicio.toIso8601String(),
      'dataFim': dataFim.toIso8601String(),
      'Lista_insumos': insumos.map((insumo) {
        return {
          'nome': insumo.nome,
          'valor': insumo.valor,
          'quantidade': insumo.quantidade,
        };
      }).toList(),
      'concluido': concluido,
      'obra': obra,
    };
  }

  // Criar uma tarefa a partir de um mapa (para leitura do armazenamento)
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      nome: map['nome'],
      descricao: map['descricao'],
      dataInicio: DateTime.parse(map['dataInicio']),
      dataFim: DateTime.parse(map['dataFim']),
      insumos: List<Insumos>.from(
        map['Lista_insumos'].map((insumo) {
          return Insumos(
            nome: insumo['nome'],
            valor: insumo['valor'],
            quantidade: insumo['quantidade'],
          );
        }),
      ),
      obra: map['obra'],
      concluido: map['concluido'],
    );
  }
}
