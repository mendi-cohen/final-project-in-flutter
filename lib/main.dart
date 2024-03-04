import 'package:flutter/material.dart';
import "MainCards.dart";
import "ViewAccount.dart";
import "newTransaction.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BudgetHomePage(
        userName: "חיים",
      ),
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

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});
  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("? מה תרצה לבצע היום  "))),
      body: Container(
          color: Colors.blue,
          height: 500,
          child:Center(child:  GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            children: [
              OptionCard(
                title: "צפייה ביתרת החשבון",
                icon: Icons.account_balance_wallet,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTransactionPage()),
                    );
                },
              ),
              OptionCard(
                title: "הוספת עסקאות חדשות",
                icon: Icons.add_circle,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTransactionPage()),
                    );
                },
              ),
              OptionCard(
                title: 'דו"ח סיכום חודשי',
                icon: Icons.account_box,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTransactionPage()),
                    );
                },
              ),
              OptionCard(
                title: " התראות תקציב ",
                icon: Icons.punch_clock_rounded,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTransactionPage()),
                    );
                },
              ),
              OptionCard(
                  title: " ניהול תקציב ",
                  icon: Icons.account_balance,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTransactionPage()),
                    );
                  },
                ),
         
            ],
          ))),
    );
  }
}



