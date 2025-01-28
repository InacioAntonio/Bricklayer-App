import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:bricklayer_app/services/notification_service.dart';
import 'package:bricklayer_app/services/obra_service.dart';
import 'package:bricklayer_app/services/task_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:bricklayer_app/services/auth_service.dart';

class ConfigureProviders {
  late final List<SingleChildWidget> providers;
  ConfigureProviders({required this.providers});
  static Future<ConfigureProviders> createDependencyTree() async {
    final realtimeService = RealtimeService();
    final authService = AuthService();
    final tarefaService = TaskManagerService();
    final notificationService = NotificationService();
    //final notification_service = NotificationService(topic: "alerta");

    return ConfigureProviders(providers: [
      Provider<RealtimeService>.value(value: realtimeService),
      ChangeNotifierProvider<AuthService>.value(value: authService),
      Provider<TaskManagerService>.value(value: tarefaService),
      Provider<NotificationService>.value(value: notificationService),
      //Provider<NotificationService>.value(value: notification_service),
    ]);
  }
}
