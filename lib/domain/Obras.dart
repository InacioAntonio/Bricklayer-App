import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:intl/intl.dart';

class Obras {
  late String nome;
  late DateTime dataInicio; // Usando DateTime
  late DateTime dataFim;
  late String descricao;
  double qtdInsumos = 0;
  List<Insumos> insumos = [];
  double valorTotal = 0;
  Obras(
      {required this.nome,
      required this.dataInicio,
      required this.dataFim,
      required this.insumos,
      required this.valorTotal,
      required this.descricao});
  // Método para formatar a data de início como string
  String get dataInicioFormatada {
    return DateFormat('dd/MM/yyyy').format(dataInicio);
  }

  // Método para formatar a data de fim como string
  String get dataFimFormatada {
    return DateFormat('dd/MM/yyyy').format(dataFim);
  }
}
