import 'dart:developer';

import 'package:http/http.dart' as http;
import 'urls.dart';
import 'model/user.dart';

class ApiService {
  Future<List<User>?> getUsers() async {
    List<User> users = List.empty(growable: true);
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        User user = userFromJson(response.body);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
        users.add(user);
      }
    } catch (e) {
      log(e.toString());
    }
    return users;
  }
}