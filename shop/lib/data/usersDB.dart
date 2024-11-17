// FILE: shop/lib/data/usersDB.dart

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/users.dart';

class UsersDB {
  static final UsersDB instance = UsersDB._init();

  UsersDB._init();

  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/users.json');
  }

  Future<void> createUser(User user) async {
    final file = await _file;
    List<User> users = await readAllUsers();
    users.add(user);
    await file.writeAsString(jsonEncode(users.map((u) => u.toMap()).toList()));
  }

  Future<List<User>> readAllUsers() async {
    try {
      final file = await _file;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        return jsonData.map((json) => User.fromMap(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> updateUser(User user) async {
    final file = await _file;
    List<User> users = await readAllUsers();
    users = users.map((u) => u.username == user.username ? user : u).toList();
    await file.writeAsString(jsonEncode(users.map((u) => u.toMap()).toList()));
  }

  Future<void> deleteUser(String username) async {
    final file = await _file;
    List<User> users = await readAllUsers();
    users.removeWhere((u) => u.username == username);
    await file.writeAsString(jsonEncode(users.map((u) => u.toMap()).toList()));
  }
}
