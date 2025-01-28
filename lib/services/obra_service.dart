import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RealtimeService {
  final database = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> cadastrarObra(Obras obra) async {
    if (user == null) {
      print("Usuário não autenticado");
      return;
    }
    String id = FirebaseAuth.instance.currentUser!.uid;
    await database.collection('users').doc(id).collection('obras').add({
      'nome': obra.nome,
      'datainicio': obra.dataInicio..toIso8601String(),
      'datafim': obra.dataFim..toIso8601String(),
      'Lista_insumos': obra.insumos.map((insumo) {
        return {
          'nome': insumo.nome,
          'valor': insumo.valor,
          'quantidade': insumo.quantidade,
        };
      }).toList(),
      'descricao': obra.descricao,
      'valorTotal': obra.valorTotal,
      'tarefas': obra.tarefas?.map((tarefa) {
        return tarefa.toMap();
      }).toList(),
      'valorMaoDeObra': obra.valorMaoDeObra,
    });
  }

  Future<void> updateObra(Obras obra) async {
    if (user == null) {
      print("Usuário não autenticado");
      return;
    }
    String id = FirebaseAuth.instance.currentUser!.uid;
    print('Atualizando obra');
    print(id);
    print(obra.nome);
    print(obra.descricao);
    try {
      await database
          .collection('users')
          .doc(id)
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
            'tarefas': obra.tarefas?.map((tarefa) {
              return tarefa.toMap();
            }).toList(),
            'valorMaoDeObra': obra.valorMaoDeObra,
          };
          element.reference.update(updates);
        }
      });
      print('Obra atualizada');
    } catch (e) {
      print("Erro ao atualizar obra: $e");
    }
  }

  Future<void> deleteObra(String nome) async {
    try {
      String id = FirebaseAuth.instance.currentUser!.uid;
      await database
          .collection('users')
          .doc(id)
          .collection('obras')
          .where('nome', isEqualTo: nome)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    } catch (e) {
      print("Erro ao deletar obra: $e");
    }
  }

  Future<List<Obras>> listarObras() async {
    if (user == null) {
      print("Usuário não autenticado");
      throw Exception("Usuário não autenticado");
    }
    try {
      //ele sabe o uid certo mas chama o errado vsfd
      String id = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot =
          await database.collection('users').doc(id).collection('obras').get();
      return querySnapshot.docs.map((doc) {
        return Obras(
          nome: doc['nome'],
          dataInicio: (doc['datainicio'] as Timestamp).toDate(),
          dataFim: (doc['datafim'] as Timestamp).toDate(),
          descricao: doc['descricao'],
          insumos: (doc['Lista_insumos'] as List).map((insumo) {
            return Insumos(
              nome: insumo['nome'],
              valor: insumo['valor'],
              quantidade: insumo['quantidade'],
            );
          }).toList(),
          valorTotal: doc['valorTotal'],
          valorMaoDeObra: doc['valorMaoDeObra'],
          tarefas: (doc['tarefas'] as List).map((tarefa) {
                return Tarefa(
                    nome: tarefa['nome'],
                    descricao: tarefa['descricao'],
                    dataInicio: (doc['datainicio'] as Timestamp).toDate(),
                    dataFim: (doc['datainicio'] as Timestamp).toDate(),
                    insumos:
                        (tarefa['Insumos_Ultilizados'] as List).map((insumo) {
                      return Insumos(
                        nome: insumo['nome'],
                        valor: insumo['valor'],
                        quantidade: insumo['quantidade'],
                      );
                    }).toList(),
                    obra: tarefa['obra'],
                    concluido: tarefa['concluido']);
              }).toList() ??
              List<Tarefa>.empty(),
        );
      }).toList();
    } catch (e) {
      print("Erro ao listar obras: $e");
    }
    return [];
  }
}
