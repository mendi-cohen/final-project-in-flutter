// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../Services/All.dart';
import '../Services/Dialog.dart';
import '../Services/deleted.dart';
import '../MonthPickerWidget.dart';

class CharidyWidget extends StatefulWidget {
  final Map<String, dynamic> userData;
  const CharidyWidget({super.key, required this.userData});
  @override
  _CharidyWidgetState createState() => _CharidyWidgetState();
}

class _CharidyWidgetState extends State<CharidyWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  bool _isMaaserSelected = false;
  List<dynamic> dataList = [];
  String? _selectedOption = 'חד פעמי';
  String? _selectedMonth;

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

///// שליחת כל צדקה למסד הנתונים

Future<void> _submitDataToDatabase() async {
  final url = Uri.parse('http://10.0.2.2:3007/charidy/sendthecharidy');
  final type = _isMaaserSelected ? 'מעשר' : 'צדקה';
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
            style: TextStyle(fontSize: 18),
            ' אנא מלא את כל השדות עם ערכים תקינים '),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(style: TextStyle(fontSize: 15), 'אישור'),
          ),
        ],
      ),
    );
    return;
  }
  String? postData;

  if (_selectedOption == 'חד פעמי' || _selectedOption == 'חודשי קבוע') {
    postData = _selectedOption;
  } else if (_selectedOption == 'לכמה חודשים') {
    postData = _selectedMonth;
  }

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      'charidy_value': amount,
      'resion': source,
      'type': postData, // שליחת המידע הנכון לשרת
      'maaser_or_charidy': type,
      'user_id': widget.userData['user']['id']
    }),
  );

  if (response.statusCode == 200) {
    await DialogService.showMessageDialog(
        context, 'הצלחה', 'התרומה התווספה בהצלחה!', Colors.green);
    _amountController.clear();
    _sourceController.clear();
     setState(() {
    _selectedOption = 'חד פעמי';
  });
  } else {
    await DialogService.showMessageDialog(
        context, 'שגיאה', 'אירעה שגיאה בתהליך ההוספה של התרומה.', Colors.red);
  }
}


///// הצגת כל התרומות החודשיות

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:3007/charidy/getcharidyByuser_id/${widget.userData['user']['id']}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['CharidyFdb'];
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
      body: SingleChildScrollView(
          child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/CharidyImage.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
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
              labelText: ' יעד התרומה ',
              hintText: ' הכנס את יעד התרומה  ',
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: _isMaaserSelected,
                    onChanged: (value) {
                      setState(() {
                        _isMaaserSelected = value ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const Text(
                    'צדקה ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  Radio(
                    value: true,
                    groupValue: _isMaaserSelected,
                    onChanged: (value) {
                      setState(() {
                        _isMaaserSelected = value ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const Text(
                    'מעשר',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
              child: Column(
                children: [
                  RadioListTile(
                    title: const Text(
                      'תרומה חד פעמית',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    value: 'חד פעמי',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value as String?;
                        print('$_selectedOption');
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text(
                      'תרומה חודשית קבועה',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    value: 'חודשי קבוע',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value as String?;
                        print('$_selectedOption');
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text(
                      'תרומה לכמה חודשים',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                    value: 'לכמה חודשים',
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value as String?;
                        print('$_selectedOption');
                      });
                    },
                  ),
                  if (_selectedOption == 'לכמה חודשים')
                    MonthPickerWidget(
                      onMonthSelected: (selectedMonth) {
                        setState(() {
                          _selectedMonth = selectedMonth;
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  _submitDataToDatabase();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                  elevation: 8,
                  shadowColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 27, 222, 73),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'תרום',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            const Center(
              child: Text(
                "תרומות קודמות :",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
                height: 270,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: dataList.map((item) {
                      String formattedDate = DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(item['createdAt']));
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            tileColor: Colors.white.withOpacity(0.1),
                            textColor: Colors.lightGreen,
                            title: Text(
                              'סכום התרומה: ${item['charidy_value']} ש"ח',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' יעד : ${item['resion']}',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'תאריך התחלת התרומה  : $formattedDate',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            trailing: DelWidget(
                              ObjectId: item['id'].toString(),
                              path: 'charidy',
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )),
            All.buildTotalIncome(dataList, 'סך הצדקה הכולל', 'charidy_value'),
          ],
        ),
      )),
    );
  }
}
