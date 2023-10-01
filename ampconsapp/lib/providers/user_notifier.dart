import 'package:ampconsapp/models/user.dart';
import 'package:ampconsapp/services/http_service.dart';
import 'package:flutter/widgets.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;

  Future<bool> fetchUser() async {
    try {
      User user = await HttpService.getUser('thisismia');
      _user = user;
      return true;
    } catch (error) {
      return false;
    }
  }

  get user {
    return _user;
  }
}
