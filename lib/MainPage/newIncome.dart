// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../Services/Sum.dart';
import '../Services/Dialog.dart';
import '../Services/deleted.dart';
import '../Services/Token.dart';
import '../Services/env.dart';
import '../Services/SerchWidget.dart';
import '../Services/pickcher.dart';

class IncomeEntryWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function() onSuccess;
  const IncomeEntryWidget(
      {super.key, required this.userData, required this.onSuccess});

  @override
  _IncomeEntryWidgetState createState() => _IncomeEntryWidgetState();
}

class _IncomeEntryWidgetState extends State<IncomeEntryWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  bool _isMonthly = false;
  List<dynamic> dataList = [];

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          labelStyle: const TextStyle(
            color: Colors.black87,
          ),
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 5, 3, 3),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    TokenManager.scheduleTokenDeletion();
    _fetchData();
  }

  Future<void> _submitDataToDatabase() async {
    final url = Uri.parse('$PATH/income/sendincome');

    final amount = _amountController.text;
    final source = _sourceController.text;
    double? parsedAmount = double.tryParse(amount);
    if (amount.isEmpty || parsedAmount == null || source.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(child: Text('שגיאה!')),
          backgroundColor: Colors.red,
          content: const Text(
            ' אנא מלא את כל השדות עם ערכים תקינים ',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'אישור',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      );
      return;
    }
    final isMonthly = _isMonthly ? "קבועה " : "חד-פעמית";

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'income_value': amount,
        'source': source,
        'monstli': isMonthly,
        'user_id': widget.userData['user']['id']
      }),
    );

    if (response.statusCode == 200) {
      await DialogService.showMessageDialog(
          context, 'הצלחה', 'ההכנסה התווספה בהצלחה!', Colors.green);
      _amountController.clear();
      _sourceController.clear();
      setState(() {
        _isMonthly = false;
        _fetchData();
        widget.onSuccess();
      });
    } else {
      await DialogService.showMessageDialog(
          context, 'שגיאה', 'אירעה שגיאה בתהליך ההוספה של ההכנסה.', Colors.red);
    }
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        '$PATH/income/getincomeByuser_id/${widget.userData['user']['id']}'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['incomsFdb'];
      setState(() {
        dataList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CircularImageSelectionWidget(text: widget.userData['user']['name'] ,)
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/incomeImage.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _amountController,
                    labelText: 'סכום(מספרים בלבד) ',
                    hintText: 'הכנס סכום',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _sourceController,
                    labelText: 'מקור ההכנסה ',
                    hintText: 'הכנס מקור הכסף ',
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.9)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isMonthly,
                              onChanged: (value) {
                                setState(() {
                                  _isMonthly = value ?? false;
                                });
                              },
                              activeColor:
                                  const Color.fromARGB(255, 40, 45, 203),
                            ),
                            const Text(
                              ' הכנסה חודשית קבועה ?',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DataSearchWidget(
                                       userData: widget.userData,
                                apiUrl:
                                    '$PATH/income/getAllConstincomesByuserid/${widget.userData['user']['id']}',
                                    type:'AllConstincomsFdb',sum: 'income_value', resion: 'source',title: "תאריך ההכנסה הראשונה",
                                    img: 'assets/images/incomeImage.jpeg',wigetTitle: 'כל ההכנסות הקבועות מתחילת' ,
                                    color: Colors.blue, text: 'סה"כ ההכנסות הקבועות השנה ',DelPath: 'income',del: true,),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent,
                                ),
                                foregroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.black87,
                                ),
                                backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.blue,
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text(
                                ' כל ההכנסות הקבועות ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      TokenManager.checkToken(context, _submitDataToDatabase);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      elevation: 8,
                      shadowColor: Colors.black,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'הכנס',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  All.buildTotalIncome(dataList, 'סך ההכנסות החודשי',
                      'income_value', Colors.blue),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        " פירוט הכנסות  :",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 18, 11, 11),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == dataList.length) {
                          return Padding(
                            padding: const EdgeInsets.all(300.0),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const SizedBox(
                                height: 300,
                              ),
                            ),
                          );
                        } else {
                          int reversedIndex = dataList.length - 1 - index;
                          String formattedSum = NumberFormat('#,###').format(
                              int.parse(
                                  dataList[reversedIndex]['income_value']));
                          String formattedDate = DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(
                                  dataList[reversedIndex]['createdAt']));

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color:
                                dataList[reversedIndex]['monstli'] != 'חד-פעמית'
                                    ? const Color.fromARGB(255, 243, 241, 232)
                                    : Colors.white,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(28),
                              tileColor: Colors.white.withOpacity(0.1),
                              textColor: const Color.fromARGB(255, 75, 27, 222),
                              title: Text(
                                'סכום ההכנסה: $formattedSum ש"ח',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'מקור: ${dataList[reversedIndex]['source']}',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'תאריך ההכנסה : $formattedDate',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(height: 10),
                                  if (dataList[reversedIndex]['monstli'] !=
                                      'חד-פעמית') ...[
                                    const SizedBox(height: 2),
                                    const Text(
                                      '* הכנסה קבועה',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 39, 218, 11),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              trailing: DelWidget(
                                ObjectId: dataList[reversedIndex]['id'].toString(),
                                path: 'income',
                                DEL: _fetchData,
                                onSuccess: widget.onSuccess,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
