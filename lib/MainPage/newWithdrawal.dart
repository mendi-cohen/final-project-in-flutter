import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Services/Sum.dart';
import '../Services/Dialog.dart';
import '../Services/deleted.dart';
import '../Services/Token.dart';
import '../Services/env.dart';

class withdrawalWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Function() onSuccess;
  const withdrawalWidget({super.key, required this.userData, required this.onSuccess}) ;

  @override
  withdrawalWidgetState createState() => withdrawalWidgetState();
}

class withdrawalWidgetState extends State<withdrawalWidget> {
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          // צבע טקסט
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
 

  //// שליחת משיכה למסד הנתונים

  Future<void> _submitDataToDatabase() async {
    final url = Uri.parse('$PATH/pool/sendthepool');

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

    final isMonthly = _isMonthly ? "קבועה" : "חד-פעמית";

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'pool_value': amount,
        'resion': source,
        'monstli': isMonthly,
        'user_id': widget.userData['user']['id']
      }),
    );

    if (response.statusCode == 200) {
      await DialogService.showMessageDialog(
          context, 'הצלחה', 'המשיכה בוצעה בהצלחה!', Colors.green);
      _amountController.clear();
      _sourceController.clear();
      _fetchData();

      setState(() {
        _isMonthly = false;
        _fetchData();
        widget.onSuccess();
      });
    } else {
      await DialogService.showMessageDialog(
          context, 'שגיאה', 'אירעה שגיאה בתהליך המשיכה.', Colors.red);
    }
  }

  //// הצגת המשיכות הקודמות

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        '$PATH/pool/getpoolByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['PoolFdb'];
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
        title: Text('  שלום לך ${widget.userData['user']['name']}'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/poolImage.jpeg'),
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
                    labelText: ' סכום(מספרים בלבד) ',
                    hintText: 'הכנס סכום',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _sourceController,
                    labelText: ' סיבת ההוצאה ',
                    hintText: 'סיבת ההוצאה ',
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isMonthly,
                          onChanged: (value) {
                            setState(() {
                              _isMonthly = value ?? false;
                            });
                          },
                          activeColor: const Color.fromARGB(255, 40, 45, 203),
                        ),
                        const Text(
                          ' הוצאה חודשית קבועה ?',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
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
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'משוך',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  All.buildTotalIncome(dataList, 'סך ההוצאות הכולל', 'pool_value', Colors.red),

                  Container(
                    color: Colors.white.withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        "פירוט עסקאות :",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 18, 11, 11),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 550,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int reversedIndex = dataList.length - 1 - index;
                        String formattedDate = DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(dataList[reversedIndex]['createdAt']));
                        return Card(
                          elevation: 10,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(28),
                            tileColor: Colors.white.withOpacity(0.1),
                            textColor: Colors.redAccent,
                            title: Text(
                              'סכום ההוצאה: ${dataList[reversedIndex]['pool_value']} ש"ח',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'סיבה: ${dataList[reversedIndex]['resion']}',
                                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'תאריך העסקה : $formattedDate',
                                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                                ),
                                      const SizedBox(height: 4),
                                    Text(
                                      ' סטטוס פעולה : ${dataList[reversedIndex]['monstli']}',
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 18,
                                      ),
                                    ),
                              ],
                            ),
                            trailing: DelWidget(
                              ObjectId: dataList[reversedIndex]['id'].toString(),
                              path: 'pool',
                              DEL: _fetchData,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
