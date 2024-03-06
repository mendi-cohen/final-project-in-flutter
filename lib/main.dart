import 'package:flutter/material.dart';
import 'MainPage/MainControll.dart';
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
       child: child!),

      home:const EnterPage()
    );
  }
}




class BudgetHomePage extends StatefulWidget {
  const BudgetHomePage({super.key, this.userName});
  final userName;
  @override
  State<BudgetHomePage> createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Center(child: Text("! שלום לך ${widget.userName}")),
      ),
      body: const MyMainPage(),
      drawer: const Column(children: [Text("Bottom")]),
    );
  }
}





