import 'package:bricklayer_app/services/obra_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:bricklayer_app/services/auth_service.dart';

class ConfigureProviders {
  late final List<SingleChildWidget> providers;
  ConfigureProviders({required this.providers});
  static Future<ConfigureProviders> createDependencyTree() async {
    final realtime_service = RealtimeService();
    //final notification_service = NotificationService(topic: "alerta");

    return ConfigureProviders(providers: [
      Provider<RealtimeService>.value(value: realtime_service),
      Provider<AuthService>.value(value: AuthService()),
      //Provider<NotificationService>.value(value: notification_service),
    ]);
  }
}
