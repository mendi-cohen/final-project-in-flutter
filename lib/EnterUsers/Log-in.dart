import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MainPage/MainControll.dart';
import 'dart:io';
// import 'package:flutter_dotenv/flutter_dotenv.dart';



class LoginPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSuccess;
  const LoginPage({super.key, required this.onSuccess}); 

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchStoredPasswords() async {
    final url = Uri.parse('http://10.0.2.2:3007/enterUser');
    final password = _passwordController.text;
    final email = _emailController.text;

    final response = await http.post(
      url,
      body: {'password': password , 'email': email},
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
      backgroundColor: Colors.red,
      content: Text(
        'ההתחברות נכשלה!',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold ,color: Colors.white),
  
      ),// מגדיל את גודל התיבה
      duration: Duration(seconds: 2),
    ),
  );
});

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'הכנס אימייל',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'הכנס סיסמה',
                ),
              ),
                const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final mydivais = Platform.isAndroid;
                 print(mydivais);
                  _fetchStoredPasswords();
                  setState(() {
                    _passwordController.text = '';
                    _emailController.text = '';
                  });
                },
                child: const Text('כניסה'),
              ),
            ],
          ),
        );
    
  }
}
