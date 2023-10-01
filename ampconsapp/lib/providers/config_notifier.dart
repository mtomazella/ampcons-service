import 'package:ampconsapp/models/config.dart';
import 'package:flutter/widgets.dart';

class ConfigNotifier extends ChangeNotifier {
  final ConfigModel _config = ConfigModel();

  bool get darkTheme {
    return _config.darkThemeEnabled;
  }

  set darkTheme(bool state) {
    _config.darkThemeEnabled = state;
    notifyListeners();
  }
}
