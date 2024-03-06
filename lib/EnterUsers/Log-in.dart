import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  List<String> _storedPasswords = [];

  @override
  void initState() {
    super.initState();
    _fetchStoredPasswords();
  }

  Future<void> _fetchStoredPasswords() async {
    final url = Uri.parse('http://10.0.2.2:3007/enterUser');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      List<String> passwords = [];
      for (var user in data) {
        passwords.add(user['password']);
      }

      setState(() {
        _storedPasswords = passwords;
        print(_storedPasswords);
      });
    } else {
      throw Exception('Failed to fetch stored passwords');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('התחברות')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'הכנס סיסמה',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final enteredPassword = _passwordController.text;
                  print(enteredPassword);
                  if (_storedPasswords.contains(enteredPassword)) {
                         ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                        content: Text('סיסמה נכונה!!!!!!!!!!!!!!!!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Password is incorrect
                    // Handle incorrect password logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                        content: Text('סיסמה שגויה'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('כניסה'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
