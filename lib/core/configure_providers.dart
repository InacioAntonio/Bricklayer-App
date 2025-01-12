import 'package:bricklayer_app/services/realtime_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  late final List<SingleChildWidget> providers;
  ConfigureProviders({required this.providers});
  static Future<ConfigureProviders> createDependencyTree() async {
    final realtime_service = RealtimeService();
    //final notification_service = NotificationService(topic: "alerta");

    return ConfigureProviders(providers: [
      Provider<RealtimeService>.value(value: realtime_service),
      //Provider<NotificationService>.value(value: notification_service),
    ]);
  }
}
