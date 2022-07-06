import 'dart:convert';

import 'package:nitya/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(json.encode(user));
    prefs.setString('user', json.encode(user));
  }

  static saveNotificationsRead(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> l = List();
    if (prefs.containsKey('NO_READ')) {
      l = prefs.getStringList('NO_READ');
    }

    if (!l.contains(id)) {
      prefs.setStringList("NO_READ", l..add(id));
    }
  }

  static Future<List<String>> getReadNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('NO_READ');
  }

  static Future<User> getLoggedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user')) {
      return User.fromJson(json.decode(prefs.getString('user')));
    }

    return null;
  }

  static deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static saveExtras(String org, String design) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("org", org);
    prefs.setString('des', design);
  }

  static getOrg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.get('org');
  }

  static getDesignation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.get('des');
  }
}
