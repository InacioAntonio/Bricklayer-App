import 'package:bricklayer_app/domain/Obras.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RealtimeService {
  final database = FirebaseFirestore.instance;
  Future<void> cadastrarObra(Obras obra) async {
    await database.collection('obras').add({
      'nome': obra.nome,
      'datainicio': obra.dataInicio,
      'datafim': obra.dataFim,
      'Lista_insumos': obra.insumos.map((insumo) {
        return {
          'nome': insumo.nome,
          'valor': insumo.valor,
          'quantidade': insumo.quantidade,
        };
      }).toList(),
      'descricao': obra.descricao,
    });
  }

  Future<void> updateObra(Obras obra) async {
    await database
        .collection('obras')
        .where('nome', isEqualTo: obra.nome)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Map<String, dynamic> updates = {
          'datainicio': obra.dataInicio,
          'datafim': obra.dataFim,
          'descricao': obra.descricao,
          'valorTotal': obra.valorTotal,
          'Lista_insumos': obra.insumos.map((insumo) {
            return {
              'nome': insumo.nome,
              'valor': insumo.valor,
              'quantidade': insumo.quantidade,
            };
          }).toList(),
        };
        element.reference.update(updates);
      }
    });
  }

  Future<void> deleteObra(String nome) async {
    await database
        .collection('obras')
        .where('nome', isEqualTo: nome)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });
  }
}
