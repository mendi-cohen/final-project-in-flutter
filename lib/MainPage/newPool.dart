import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PoolWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  const PoolWidget({super.key, required this.userData});
  @override
  poolWidgetState createState() => poolWidgetState();
}

class poolWidgetState extends State<PoolWidget> {
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
    _fetchData();
  }

  //// שליחת משיכה למסד הנתונים

  Future<void> _submitDataToDatabase() async {
    final url = Uri.parse('http://10.0.2.2:3007/pool/sendthepool');

    final amount = _amountController.text;
    final source = _sourceController.text;

    if (amount.isEmpty || source.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('שגיאה'),
          content: const Text('אנא מלא את כל השדות'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('אישור'),
            ),
          ],
        ),
      );
      return;
    }

    final isMonthly = _isMonthly.toString();

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
      _amountController.clear();
      _sourceController.clear();
      setState(() {
        _isMonthly = false;
      });
    }
  }

//// הצגת המשיכות הקודמות

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3007/pool/getpoolByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['PoolFdb'];
      setState(() {
        dataList = List<Map<String, dynamic>>.from(
            data.map((entry) => entry as Map<String, dynamic>));
      });
      print(dataList);
    }
  }

  /// סך כל ההוצאות

  Widget _buildTotalIncome() {
    double totalIncome = 0;
    for (var data in dataList) {
      totalIncome += double.parse(data['pool_value']);
    }
    return Container(
      color: const Color.fromARGB(255, 195, 215, 232),
      width: 300,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        'סך ההוצאות הכולל: ${totalIncome.toStringAsFixed(2)}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('  שלום לך ${widget.userData['user']['name']}'),
      ),
      body: SingleChildScrollView(child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/poolImage.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _amountController,
              labelText: 'סכום',
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
                )),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  _submitDataToDatabase();
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
                )),
            const Center(child: Text( style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold) ," הוצאות קודמות :")),
            SizedBox(
              height: 450,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  String formattedDate = DateFormat('dd/MM/yyyy')
                      .format(DateTime.parse(dataList[index]['createdAt']));
                  String formattedTime = DateFormat('HH:mm')
                      .format(DateTime.parse(dataList[index]['createdAt']));
                  return Card(
                    elevation: 10,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      tileColor: Colors.white,
                      textColor: Colors.redAccent,
                      title: Text(
                        'סכום ההוצאה: ${dataList[index]['pool_value']} ש"ח',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'סיבה: ${dataList[index]['resion']}',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'תאריך ביצוע העסקה : ${formattedDate}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'שעת ביצוע העסקה : ${formattedTime}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildTotalIncome(),
          ],
        ),
      ),
    ));
  }
}
