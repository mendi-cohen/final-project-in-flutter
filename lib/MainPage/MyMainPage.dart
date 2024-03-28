import 'package:flutter/material.dart';
import "../Services/MainCards.dart";
import "newPool.dart";
import "newIncome.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Services/AllTugether.dart';
import './charidy.dart';

class MyMainPage extends StatefulWidget {
   final Map<String, dynamic> userData; 
  const MyMainPage({super.key, required this.userData}) ;
  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  List<dynamic> poolList = [];
  List<dynamic> incomeList = [];

  @override
  

void didChangeDependencies() {
  super.didChangeDependencies();
  _fetchPoolData();
  _fetchIncomeData();
  
}


  Future<void> _fetchPoolData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3007/pool/getpoolByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['PoolFdb'];
      setState(() {
        poolList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
      print("KKKKKKKKKKK$poolList");

    }
  }


    Future<void> _fetchIncomeData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3007/income/getincomeByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['incomsFdb'];
      setState(() {
        incomeList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
      print("OOOOOOOOOO$incomeList");
    }
  }
  

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
        child:  GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 3,
          mainAxisSpacing: 20,
          children: [
            Row(
              children: [
                OptionCard(
                  title: " הכנסות  ",
                  icon: Icons.attach_money,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IncomeEntryWidget(userData:widget.userData)),
                    );
                  },
                ),
                OptionCard(
                  title: " הוצאות ",
                  icon: Icons.shopping_cart,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PoolWidget(userData:widget.userData)),
                    );
                  },
                ),
              ],
            ),
                   OptionCard(
                  title: " צדקה / מעשרות ",
                  icon: Icons.volunteer_activism,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CharidyWidget(userData:widget.userData)),
                    );
                  },
                ),
            const SizedBox(),
            const SizedBox(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                child: AllTuether.buildTotalAccount(incomeList , poolList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
