import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static final String _adminUsername = 'admin';
  static final String _adminPassword = 'admin123';
  static const String _usersKey = 'birthday_app_users';

  List<User> _users = [
    User(username: 'user1', password: 'pass1', createdAt: DateTime.now()),
    User(username: 'user2', password: 'pass2', createdAt: DateTime.now()),
  ];

  AuthService() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson != null) {
      final List<dynamic> usersList = json.decode(usersJson);
      _users = usersList.map((userJson) => User.fromJson(userJson)).toList();
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = json.encode(_users.map((user) => user.toJson()).toList());
    await prefs.setString(_usersKey, usersJson);
  }

  bool authenticateAdmin(String username, String password) {
    return username == _adminUsername && password == _adminPassword;
  }

  bool authenticateUser(String username, String password) {
    return _users
        .any((user) => user.username == username && user.password == password);
  }

  Future<void> addUser(String username, String password,
      {String? email}) async {
    _users.add(User(
      username: username,
      password: password,
      email: email,
      createdAt: DateTime.now(),
    ));
    await _saveUsers();
  }

  List<User> getUsers() {
    return _users;
  }

  Future<bool> deleteUser(String username) async {
    final initialLength = _users.length;
    _users.removeWhere((user) => user.username == username);
    if (_users.length != initialLength) {
      await _saveUsers();
      return true;
    }
    return false;
  }
}
