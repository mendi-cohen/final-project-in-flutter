// ignore: file_names
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
import '../Services/SerchWidget.dart';

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
        child: Center(
            child: GridView.count(
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
                              two: DataSearchWidget(
                                apiUrl:
                                    '$PATH/income/getAllincomesByuserid/${widget.userData['user']['id']}',
                                    type:'AllincomsFdb',sum: 'income_value', resion: 'source',title: "תאריך ההכנסה",
                                    img: 'assets/images/incomeImage.jpeg',wigetTitle: 'כל ההכנסות מתחילת' ,
                                    color: Colors.blue, text: 'סה"כ הכנסת השנה',DelPath: 'income',),),
                                    
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
                          two:  DataSearchWidget(
                                apiUrl:
                                    '$PATH/pool/getAllpoolByuserid/${widget.userData['user']['id']}',type:'AllPoolFdb',
                                    sum: 'pool_value', resion: 'resion',title: 'תאריך המשיכה',img: 'assets/images/poolImage.jpeg', 
                                    wigetTitle: 'כל ההוצאות מתחילת' ,color:Colors.red ,text: 'סה"כ הוצאת השנה',DelPath: 'pool',),
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
                      two:  DataSearchWidget(
                                apiUrl:
                                    '$PATH/charidy/getAllCharidyByuserid/${widget.userData['user']['id']}',type:'AllCharidy',
                                    sum: 'charidy_value',resion: 'resion',title: 'תאריך ביצוע התרומה',img: 'assets/images/CharidyImage.jpeg',
                                    wigetTitle: 'כל התרומות מתחילת',color: const Color.fromARGB(255, 94, 217, 98),
                                     text: 'סה"כ תרמת השנה',DelPath: 'charidy',),
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
