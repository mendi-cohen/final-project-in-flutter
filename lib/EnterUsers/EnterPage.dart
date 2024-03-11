import 'package:flutter/material.dart';
import 'Log-in.dart';
import './Sign-in.dart';
import 'Logo.dart';

class EnterPage extends StatefulWidget {
  const EnterPage({super.key});
  @override
  State<EnterPage> createState() => _EnterState();
}

class _EnterState extends State<EnterPage> {
  bool _isLoginFormVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 500,
        decoration: const BoxDecoration(
          image: DecorationImage(
            // image: NetworkImage('https://th.bing.com/th/id/OIG1.WPuag1a7wiT_PyIpmIUq?pid=ImgGn'),
            image: AssetImage('assets/images/image-enterPage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Padding(
  padding: const EdgeInsets.all(8.0),
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => RegistrationForm(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              
              position: Tween<Offset>(
                begin: Offset(0, -1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
              
            );
          },
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      elevation: 5,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: const Text(
      "הרשמה",
      style: TextStyle(fontSize: 20),
    ),
  ),
),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoginFormVisible = !_isLoginFormVisible;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                       padding:const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                      elevation: 5,
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      "כניסה",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: _isLoginFormVisible
                  ? MediaQuery.of(context).size.height * 0.3
                  : 0,
              color: Colors.blue,
              child: Center(child: LoginPage(onSuccess: (userData) {
                setState(() {
                  print("Welcome: ${userData}");
                  _isLoginFormVisible = false;
                });
              })),
            ),
          ],
        ),
      ),
    );
  }
}
