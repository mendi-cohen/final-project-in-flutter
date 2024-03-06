import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './WelcomeTitle .dart';
import '../MainPage/MainControll.dart';

class RegistrationForm extends StatefulWidget {
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _registrationStatus = '';

  Future<void> _submitForm() async {
    final url = Uri.parse('http://10.0.2.2:3007/saveUser');

    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    if (!_isUsernameValid(username)) {
      setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text( ' *שם המשתמש חייב להכיל לפחות 6 תווים '),
          duration: Duration(seconds: 2),
        ),
      );
      });
      return;
    }

    if (!_isPasswordValid(password)) {
      setState(() {

               ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text( '*הסיסמא חייבת להכיל : \n לפחות אות אחת ומספר אחד\nולהיות לפחות 6 תווים'),
          duration: Duration(seconds: 2),
        ),
      );
      });

      return;
    }

    if (!_isEmailValid(email)) {
      setState(() {
                   ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('*האימייל לא תקין'),
          duration: Duration(seconds: 2),
        ),
      );
      });
      return;
    }

    final response = await http.post(
      url,
      body: {
        'userName': username,
        'password': password,
        'email': email,
      },
    );

    if (response.statusCode == 200) {
        setState(() {
    _registrationStatus = ' !ההרשמה עברה בהצלחה ';
  });
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyMainPage()),
    );
  });
    } else if (response.statusCode == 409) {
      setState(() {
               ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text(' אופס: האימייל כבר קיים במערכת!'),
          duration: Duration(seconds: 2),
        ),
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

  bool _isUsernameValid(String username) {
    return username.length >= 6;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6 &&
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
  }

  bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(' טופס הרשמה '),
        ),
      ),
      body:  Container(
          // height: 600,
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WelcomeTitle(),
          Card(
            color: Colors.amberAccent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: '*שם משתמש'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: '*סיסמא'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: '*אימייל'),
                  ),
                  const SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () {
                      final userName = _usernameController.text;
                      final password = _passwordController.text;
                      final email = _emailController.text;
                      print('Username: $userName');
                      print('Password: $password');
                      print('Email: $email');

                      _submitForm();
                    },
                    child: const Text('הרשם'),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    _registrationStatus,
                    style: TextStyle(
                        fontSize: 20,
                        color: _registrationStatus == ' !ההרשמה עברה בהצלחה '
                            ? Colors.green
                            : Colors.red),
                    textAlign: TextAlign.center,
                  ),
            
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
