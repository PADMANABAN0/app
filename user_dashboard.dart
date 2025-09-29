import 'package:flutter/material.dart';
import '../birthday_flow/birthday_flow_screen.dart';

class UserDashboard extends StatelessWidget {
  final String username;

  const UserDashboard({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BirthdayFlowScreen(username: username);
  }
}
