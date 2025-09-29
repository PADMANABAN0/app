import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'user_dashboard.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isAdmin = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    await Future.delayed(Duration(seconds: 1));

    try {
      if (_isAdmin) {
        if (_authService.authenticateAdmin(username, password)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        } else {
          _showError('Invalid admin credentials');
        }
      } else {
        if (_authService.authenticateUser(username, password)) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserDashboard(username: username)),
          );
        } else {
          _showError('Invalid user credentials');
        }
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Icon(
                Icons.cake,
                size: 80,
                color: Colors.purple,
              ),
              SizedBox(height: 20),
              Text(
                'Birthday Surprise',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Create magical birthday experiences',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.purple[700],
                ),
              ),
              SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: ChoiceChip(
                                  label: Text('User'),
                                  selected: !_isAdmin,
                                  onSelected: (selected) {
                                    setState(() => _isAdmin = !selected);
                                  },
                                  selectedColor: Colors.purple,
                                  labelStyle: TextStyle(
                                    color: !_isAdmin
                                        ? Colors.white
                                        : Colors.purple,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ChoiceChip(
                                  label: Text('Admin'),
                                  selected: _isAdmin,
                                  onSelected: (selected) {
                                    setState(() => _isAdmin = selected);
                                  },
                                  selectedColor: Colors.purple,
                                  labelStyle: TextStyle(
                                    color:
                                        _isAdmin ? Colors.white : Colors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.length < 4) {
                              return 'Password must be at least 4 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        CustomButton(
                          text: 'Login',
                          onPressed: _login,
                          backgroundColor: Colors.purple,
                          isLoading: _isLoading,
                          icon: Icons.login,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_isAdmin)
                Card(
                  color: Colors.purple[100],
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Demo Admin Credentials',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[900],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Username: admin\nPassword: admin123',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.purple[800]),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Text(
                'User demo: user1/pass1 or user2/pass2',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
