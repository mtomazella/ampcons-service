import 'package:ampconsapp/providers/user_notifier.dart';
import 'package:provider/provider.dart';

class UserProvider {
  static ChangeNotifierProvider<UserNotifier> getProvider() => _instance;

  static final ChangeNotifierProvider<UserNotifier> _instance =
      ChangeNotifierProvider(
    create: (_) => UserNotifier(),
  );
}
