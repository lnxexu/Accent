import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _usernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isUsernameValid = false;

  void _validateUsername() {
    // Simulate a database check
    setState(() {
      _isUsernameValid = _usernameController.text == 'validUsername';
    });
  }

  void _updatePassword() {
    if (_newPasswordController.text == _confirmPasswordController.text) {
      // Simulate password update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isUsernameValid ? _buildPasswordResetForm() : _buildUsernameForm(),
      ),
    );
  }

  Widget _buildUsernameForm() {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(labelText: 'Username'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _validateUsername,
          child: Text('Next'),
        ),
      ],
    );
  }

  Widget _buildPasswordResetForm() {
    return Column(
      children: [
        TextField(
          controller: _newPasswordController,
          decoration: InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(labelText: 'Confirm Password'),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _updatePassword,
          child: Text('Update Password'),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
  ));
}
