import 'package:flutter/material.dart';
import "../MainCards.dart";
import "ViewAccount.dart";
import "newTransaction.dart";

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