import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './Services/All.dart';
import 'Services/titleForCharidyTable.dart';

class CharidyTableWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const CharidyTableWidget({super.key, required this.userData});

  @override
  _CharidyTableWidgetState createState() => _CharidyTableWidgetState();
}

class _CharidyTableWidgetState extends State<CharidyTableWidget> {
  List<Map<String, dynamic>> dataListMaaser = [];
  List<Map<String, dynamic>> dataListIncome = [];
  List<Map<String, dynamic>> dataListCharidy = [];

  Future<void> _fetchDataMaaser() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3007/charidy/getMaaserByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['MaaserFdb'];
      setState(() {
        dataListMaaser = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  Future<void> _fetchDataIncome() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3007/income/getincomeByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['incomsFdb'];
      setState(() {
        dataListIncome = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  Future<void> _fetchDataCharidy() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3007/charidy/getOnlyCharidyByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['OnlyCharidy'];
      setState(() {
        dataListCharidy = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataMaaser();
    _fetchDataIncome();
    _fetchDataCharidy();
  }

  List<Map<String, dynamic>> calculateRemainingIncome(
      List<Map<String, dynamic>> originalIncomeList,
      List<Map<String, dynamic>> charidyList) {
    final double tenPercentOfOriginalIncome = originalIncomeList
        .map((item) => double.parse(item['income_value'] ?? '0'))
        .fold(0, (acc, value) => acc + value * 0.1);

    final double newIncome = tenPercentOfOriginalIncome;

    final double charidyTotal = charidyList
        .map((item) => double.parse(item['charidy_value'] ?? '0'))
        .fold(0, (acc, value) => acc + value);
    return [
      {
        'income_value': (newIncome - charidyTotal).toString(),
      }
    ];
  }

  List<Map<String, dynamic>> calculateIncome(
      List<Map<String, dynamic>> originalIncomeList) {
    final double tenPercentOfOriginalIncome = originalIncomeList
        .map((item) => double.parse(item['income_value'] ?? '0'))
        .fold(0, (acc, value) => acc + value * 0.1);

    final double newIncome = tenPercentOfOriginalIncome;
    return [
      {
        'income_value': (newIncome).toString(),
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dataListIncomeModified =
        calculateRemainingIncome(dataListIncome, dataListMaaser);
    final List<Map<String, dynamic>> dataListIncomeOnly =
        calculateIncome(dataListIncome);

    return Scaffold(
      appBar: AppBar(
        title: Text('שלום ${widget.userData['user']['name']}'),
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/maaserImage.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
                const SizedBox(
                height: 20,
              ),
              const TitleForCharidyTable(
                title: 'סיכום המעשר החודשי',
              ),
              SizedBox(
                  height: 200,
                  child: dataListMaaser.isEmpty
                      ? const Center(
                          child: TitleForCharidyTable( title: " אין נתונים זמינים ",color: Colors.black))
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: dataListMaaser.length,
                          itemBuilder: (context, index) {
                            final item = dataListMaaser[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  // פעולה בלחיצה על כל פריט - לדוגמה: פתיחת עמוד פרטים
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 30,
                                      child:
                                          Text('${item['charidy_value']} ש"ח'),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ' עבור: ${item['resion']} ',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ' סיום התרומה: ${item['type']} ',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
              Center(
                  child: All.buildTotalIncome(
                      dataListIncomeOnly,
                      'סך המעשרות הכולל',
                      'income_value',
                      const Color.fromARGB(255, 234, 215, 36))),
              const SizedBox(
                height: 5,
              ),
              Center(
                  child: All.buildTotalIncome(
                      dataListIncomeModified,
                      'סך המעשרות שנותר להפריש',
                      'income_value',
                      const Color.fromARGB(255, 234, 215, 36))),
              const SizedBox(
                height: 80,
              ),
              const TitleForCharidyTable(
                title: 'סיכום הצדקה החודשית',
              ),
              SizedBox(
                  height: 200,
                  child: dataListCharidy.isEmpty
                      ? const Center(
                          child: TitleForCharidyTable( title: " אין נתונים זמינים ",color: Colors.black) )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: dataListCharidy.length,
                          itemBuilder: (context, index) {
                            final item = dataListCharidy[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 30,
                                      child:
                                          Text('${item['charidy_value']} ש"ח'),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ' עבור: ${item['resion']} ',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      ' סיום התרומה: ${item['type']} ',
                                      style: const TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
              Center(
                  child: All.buildTotalIncome(
                      dataListCharidy,
                      'סך הצדקה הכולל',
                      'charidy_value',
                      const Color.fromARGB(255, 234, 215, 36))),
            ],
          )),
    );
  }
}
