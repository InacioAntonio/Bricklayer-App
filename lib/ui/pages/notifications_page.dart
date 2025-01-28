import 'package:bricklayer_app/domain/Obras.dart';
import 'package:bricklayer_app/services/notification_service.dart';
import 'package:bricklayer_app/services/obra_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importe suas classes de domínio

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late RealtimeService _realtimeService;
  late NotificationService _notificationService;
  List<Obras> _obras = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _realtimeService = Provider.of<RealtimeService>(context, listen: false);
      _notificationService =
          Provider.of<NotificationService>(context, listen: false);
      _loadObras();
    });
  }

  // Carregar obras do Firebase
  Future<void> _loadObras() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _obras = await _realtimeService.listarObras();
      // Verificar prazos após carregar as obras
      _notificationService.checkDeadlines(_obras);
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao carregar obras: $e";
      });
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Atualizar manualmente a lista de obras
  Future<void> _refreshObras() async {
    await _loadObras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificações'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshObras,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Obras e Tarefas com Prazos Próximos',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ..._obras.map((obra) {
                        return ExpansionTile(
                          title: Text(obra.nome),
                          subtitle: Text('Prazo: ${obra.dataFimFormatada}'),
                          trailing: Icon(Icons.notifications),
                          children: [
                            ListTile(
                              title: Text('Notificar sobre esta obra'),
                              trailing: Icon(Icons.notifications_active),
                              onTap: () {
                                _notificationService.showNotification(
                                  id: obra.hashCode,
                                  title: 'Lembrete de Obra',
                                  body:
                                      'O prazo da obra "${obra.nome}" está se aproximando!',
                                );
                              },
                            ),
                            ...(obra.tarefas ?? []).map((tarefa) {
                              return ListTile(
                                title: Text(tarefa.nome),
                                subtitle:
                                    Text('Prazo: ${tarefa.dataFimFormatada}'),
                                trailing: Icon(Icons.notifications),
                                onTap: () {
                                  _notificationService.showNotification(
                                    id: tarefa.hashCode,
                                    title: 'Lembrete de Tarefa',
                                    body:
                                        'O prazo da tarefa "${tarefa.nome}" está se aproximando!',
                                  );
                                },
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
    );
  }
}
