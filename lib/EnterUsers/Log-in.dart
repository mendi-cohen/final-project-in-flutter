import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../MainPage/MyMainPage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';




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
    final url = Uri.parse('${dotenv.env['PATH']}/enterUser');
    final password = _passwordController.text;
    final email = _emailController.text;
    WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

    final response = await http.post(
      url,
      body: {'password': password , 'email': email},
    );
    if (response.statusCode == 200) {
      final userData = json.decode(response.body); 
      widget.onSuccess(userData); 
      MyMainPage(userData: userData);
      localStorage.setItem('Token', userData['token'].toString());

      
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
  
      ),
      duration: Duration(seconds: 2),
    ),
  );
});

    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
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

