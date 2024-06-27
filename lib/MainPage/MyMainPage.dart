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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './charidy.dart';
import './CharidyTable.dart';
import '../Services/SerchWidget.dart';
import '../Services/pickcher.dart';
import '../Services/AnimationTitle.dart';

class MyMainPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const MyMainPage({super.key, required this.userData});
  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  List<dynamic> poolList = [];
  List<dynamic> incomeList = [];
  List<dynamic> charidyList = [];
  
  @override
  void initState() {
    super.initState();
    _fetchPoolData();
    _fetchIncomeData();
    _fetchCharidyData();
  }

  Future<void> _fetchPoolData() async {
    final response = await http.get(Uri.parse(
        '${dotenv.env['PATH']}/pool/getpoolByuser_id/${widget.userData['user']['id']}'));

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
        '${dotenv.env['PATH']}/income/getincomeByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['incomsFdb'];
      setState(() {
        incomeList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  Future<void> _fetchCharidyData() async {
    final response = await http.get(Uri.parse(
        '${dotenv.env['PATH']}/charidy/getcharidyByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['CharidyFdb'];
      setState(() {
        charidyList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: CircularImageSelectionWidget(text: widget.userData['user']['name'] ,)
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            userData: widget.userData,
                            apiUrl:
                                '${dotenv.env['PATH']}/income/getAllincomesByuserid/${widget.userData['user']['id']}',
                            type: 'AllincomsFdb',
                            sum: 'income_value',
                            resion: 'source',
                            title: "תאריך ההכנסה",
                            img: 'assets/images/incomeImage.jpeg',
                            wigetTitle: 'כל ההכנסות מתחילת',
                            color: Colors.blue,
                            text: 'סה"כ הכנסת השנה',
                            DelPath: 'income',
                            del: false,
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
                const SizedBox(height: 16),
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
                          two: DataSearchWidget(
                             userData: widget.userData,
                            apiUrl:
                                '${dotenv.env['PATH']}/pool/getAllpoolByuserid/${widget.userData['user']['id']}',
                            type: 'AllPoolFdb',
                            sum: 'pool_value',
                            resion: 'resion',
                            title: 'תאריך המשיכה',
                            img: 'assets/images/poolImage.jpeg',
                            wigetTitle: 'כל ההוצאות מתחילת',
                            color: Colors.red,
                            text: 'סה"כ הוצאת השנה',
                            DelPath: 'pool',
                            del: false,
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
                const SizedBox(height: 16),
                OptionCard(
                  title: " צדקה / מעשרות ",
                  icon: Icons.volunteer_activism,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BottomNavigationDemo(
                          userData: widget.userData,
                          one: CharidyWidget(
                            userData: widget.userData,
                            onSuccess: _fetchCharidyData,
                          ),
                          two: DataSearchWidget(
                             userData: widget.userData,
                            apiUrl:
                                '${dotenv.env['PATH']}/charidy/getAllCharidyByuserid/${widget.userData['user']['id']}',
                            type: 'AllCharidy',
                            sum: 'charidy_value',
                            resion: 'resion',
                            title: 'תאריך ביצוע התרומה',
                            img: 'assets/images/CharidyImage.jpeg',
                            wigetTitle: 'כל התרומות מתחילת',
                            color: const Color.fromARGB(255, 94, 217, 98),
                            text: 'סה"כ תרמת השנה',
                            DelPath: 'charidy',
                            del: false,
                          ),
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
                TextAnimationWidget(title: ' שלום ${widget.userData['user']['name']} כמה נחסוך היום?',fontSize: 20,),
                const SizedBox(height: 300),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    child: AllTuether.buildTotalAccount(
                        incomeList, poolList, charidyList),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
