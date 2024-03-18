import 'package:flutter/material.dart';
import "../MainCards.dart";
import "newPool.dart";
import "newIncome.dart";

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mainImage.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
          child:Center(child:  GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            children: [
              
              OptionCard(
                title: " הכנסות  ",
                icon: Icons.account_balance_wallet,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  IncomeEntryWidget(userData:widget.userData)),
                    );
                },
              ),
              OptionCard(
                title: "הוספת עסקאות חדשות",
                icon: Icons.add_circle,
                onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PoolWidget(userData:widget.userData)),
                    );
                },
              ),        
            ],
          ))),
    );
  }
}
