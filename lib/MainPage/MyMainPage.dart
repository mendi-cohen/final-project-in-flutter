import 'dart:async';
import 'package:flutter/material.dart';
import "../Services/MainCards.dart";
import "newWithdrawal.dart";
import "newIncome.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Services/AllTugether.dart';
import 'package:localstorage/localstorage.dart';
import './BottomNavigation.dart';
import '../Services/env.dart';
import './charidy.dart';
import './CharidyTable.dart';
import '../Services/SpecialDate.dart';

class MyMainPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const MyMainPage({super.key, required this.userData});
  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  List<dynamic> poolList = [];
  List<dynamic> incomeList = [];
  @override
  void initState() {
    super.initState();
    _fetchPoolData();
    _fetchIncomeData();
  }

  Future<void> _fetchPoolData() async {
    final response = await http.get(Uri.parse(
        '$PATH/pool/getpoolByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final token = localStorage.getItem('Token');
      print('the token is : $token');
      final data = jsonDecode(response.body)['PoolFdb'];
      setState(() {
        poolList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  Future<void> _fetchIncomeData() async {
    final response = await http.get(Uri.parse(
        '$PATH/income/getincomeByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['incomsFdb'];
      setState(() {
        incomeList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
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
        child: Center(child:  GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 3,
        
          children: [
            Row(
              children: [
                OptionCard(
                  title: " הכנסות  ",
                  icon: Icons.attach_money,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BottomNavigationDemo(
                          userData: widget.userData,
                          one: IncomeEntryWidget(
                            userData: widget.userData,
                            onSuccess: _fetchIncomeData,
                          ),
                          two: IncomeEntryWidget(
                            userData: widget.userData,
                            onSuccess: _fetchIncomeData,
                          ),
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                OptionCard(
                  title: " הוצאות ",
                  icon: Icons.shopping_cart,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BottomNavigationDemo(
                          userData: widget.userData,
                          one: withdrawalWidget(
                            userData: widget.userData,
                            onSuccess: _fetchPoolData,
                          ),
                          two: withdrawalWidget(
                            userData: widget.userData,
                            onSuccess: _fetchPoolData,
                          ),
                        ),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(-1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                      ),
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
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => BottomNavigationDemo(
                      userData: widget.userData,
                      one: CharidyWidget(userData: widget.userData),
                      two:HebrewDateWidget(userData: widget.userData,),
                      three: CharidyTableWidget(userData: widget.userData),
                    ),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 1.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(),
            const SizedBox(),
            
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                child: AllTuether.buildTotalAccount(incomeList, poolList),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
