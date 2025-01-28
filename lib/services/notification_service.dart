import 'package:bricklayer_app/domain/Obras.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inicialização do serviço
  Future<void> initialize() async {
    // Configuração inicial (já implementada)
  }

  // Verificar prazos de obras e tarefas
  Future<void> checkDeadlines(List<Obras> obras) async {
    final now = DateTime.now();

    for (var obra in obras) {
      // Verificar prazo da obra
      if (obra.dataFim.isAfter(now) &&
          obra.dataFim.difference(now).inDays <= 1) {
        await showNotification(
          id: obra.hashCode,
          title: 'Prazo da Obra',
          body: 'O prazo da obra "${obra.nome}" está se aproximando!',
        );
      }

      // Verificar prazos das tarefas da obra
      for (var tarefa in obra.tarefas ?? []) {
        if (tarefa.dataFim.isAfter(now) &&
            tarefa.dataFim.difference(now).inDays <= 1) {
          await showNotification(
            id: tarefa.hashCode,
            title: 'Prazo da Tarefa',
            body:
                'O prazo da tarefa "${tarefa.nome}" da obra "${obra.nome}" está se aproximando!',
          );
        }
      }
    }
  }

  // Exibir notificação simples (já implementada)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // Implementação já existente
  }
}
