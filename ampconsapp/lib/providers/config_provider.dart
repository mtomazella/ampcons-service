import 'package:ampconsapp/providers/config_notifier.dart';
import 'package:provider/provider.dart';

class ConfigProvider {
  static ChangeNotifierProvider<ConfigNotifier> getProvider() => _instance;

  static final ChangeNotifierProvider<ConfigNotifier> _instance =
      ChangeNotifierProvider(
    create: (_) => ConfigNotifier(),
  );
}
