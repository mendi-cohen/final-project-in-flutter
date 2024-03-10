import 'package:flutter/material.dart';
import "../MainCards.dart";
import "ViewAccount.dart";
import "newTransaction.dart";

class MyMainPage extends StatefulWidget {
   final Map<String, dynamic> userData; 
  const MyMainPage({super.key, required this.userData}) ;
  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {

  @override
  
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
  title: Center(
    child: Text(
      " שלום לך  ${widget.userData['user']['name']}",
      textAlign: TextAlign.center,
    ),
  ),
),
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
                      MaterialPageRoute(builder: (context) => IncomeEntryWidget()),
                    );
                },
              ),
              OptionCard(
                title: "הוספת עסקאות חדשות",
                icon: Icons.add_circle,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IncomeEntryWidget()),
                    );
                },
              ),        
            ],
          ))),
    );
  }
}
