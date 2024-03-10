import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MainPage/MainControll.dart';

class LoginPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSuccess;
  const LoginPage({super.key, required this.onSuccess}); 

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchStoredPasswords() async {
    final url = Uri.parse('http://10.0.2.2:3007/enterUser');
    final password = _passwordController.text;

    final response = await http.post(
      url,
      body: {'password': password},
    );
    if (response.statusCode == 200) {
      final userData = json.decode(response.body); 
      widget.onSuccess(userData); 
      MyMainPage(userData: userData);
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyMainPage(userData: userData)),
        );
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(' ההרשמה נכשלה!'),
            duration: Duration(seconds: 2),
          ),
        );
      });
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
                  _fetchStoredPasswords();
                  setState(() {
                    _passwordController.text = '';
                  });
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
