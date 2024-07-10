import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './WelcomeTitle.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Services/ShowFlushBar.dart';

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
    final url = Uri.parse('${dotenv.env['PATH']}/saveUser');

    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    if (!_isUsernameValid(username)) {
      showErrorFlushbar(context, 'שם המשתמש חייב להכיל לפחות 6 תווים');
      return;
    }

    if (!_isPasswordValid(password)) {
      showErrorFlushbar(context, 'הסיסמא חייבת להכיל אות מספר ולהיות בעלת 6 תווים לפחות');
      return;
    }

    if (!_isEmailValid(email)) {
      showErrorFlushbar(context, 'האימייל לא תקין');
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
      showErrorFlushbar(context, 'הסיסמא חייבת להכיל אות מספר ולהיות בעלת 6 תווים לפחות');

      });
      Future.delayed(const Duration(seconds: 2), () {});
    } else if (response.statusCode == 409) {
      showErrorFlushbar(context, 'אופס: האימייל כבר קיים במערכת!');
    } else {
      showErrorFlushbar(context, 'ההרשמה נכשלה!');
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signIn-image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WelcomeTitle(), // Assuming WelcomeTitle is a custom widget you've defined
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: '*שם משתמש',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '*סיסמא',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: '*אימייל',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('הרשם'),
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: const Color.fromARGB(255, 246, 231, 94),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _registrationStatus,
                      style: TextStyle(
                        fontSize: 20,
                        color: _registrationStatus == ' !ההרשמה עברה בהצלחה '
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
