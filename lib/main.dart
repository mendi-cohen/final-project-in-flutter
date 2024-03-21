import 'package:flutter/material.dart';
import 'MainPage/MyMainPage.dart';
import 'EnterUsers/EnterPage.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
       child: Material(child:child!)),

      home:const EnterPage()
    );
  }
}










