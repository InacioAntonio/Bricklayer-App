import 'package:bricklayer_app/domain/Insumos.dart';

class Obras {
  late String diainicio;
  late String mesinicio;
  late String anoinicio;
  get datainicioformada => '$diainicio/$mesinicio/$anoinicio';
  late String diafim;
  late String mesfim;
  late String anofim;
  get datafimformada => '$diafim/$mesfim/$anofim';
  late String descricao;
  double qtdInsumos = 0;
  List<Insumos> insumos = [];
  double valorTotal = 0;
  Obras(
      {required this.diainicio,
      required this.mesinicio,
      required this.anoinicio,
      required this.diafim,
      required this.mesfim,
      required this.anofim,
      required this.insumos,
      required this.valorTotal,
      required this.descricao});
}
