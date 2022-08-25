import 'package:flutter/cupertino.dart';

class MainProvider extends ChangeNotifier {
  String name = '';

  String get getName => name;

  set setName(String name) {
    this.name = name;
    notifyListeners();
  }

  String email = '';

  get getEmail => email;

  set setEmail(email) {
    this.email = email;
    notifyListeners();
  }

  bool userActive = false;

  bool get getUserActive => userActive;

  set setUserActive(bool userActive) {
    this.userActive = userActive;
    notifyListeners();
  }
}
