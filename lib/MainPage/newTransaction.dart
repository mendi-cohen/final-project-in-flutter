import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class IncomeEntryWidget extends StatefulWidget {
    final Map<String, dynamic> userData; 
  const IncomeEntryWidget({super.key, required this.userData}) ;
  @override
  _IncomeEntryWidgetState createState() => _IncomeEntryWidgetState();
}

class _IncomeEntryWidgetState extends State<IncomeEntryWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  bool _isMonthly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('  שלום לך ${widget.userData['user']['name']} מה תרצה להכניס'),
      ),
      body: Padding(
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
            SizedBox(height: 10),
            _buildTextField(
              controller: _sourceController,
              labelText: 'מקור ההכנסה ',
              hintText: 'הכנס מקור הכסף ',
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isMonthly,
                  onChanged: (value) {
                    setState(() {
                      _isMonthly = value ?? false;
                    });
                  },
                ),
                Text('הכנסה חודשית קבועה'),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _submitDataToDatabase();
              },
              child: Text('הכנס'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> _submitDataToDatabase() async {
  final url = Uri.parse('http://10.0.2.2:3007/income/sendincome');

  final amount = _amountController.text;
  final source = _sourceController.text;
  final isMonthly = _isMonthly.toString(); 

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
    print("Success!!!!!!!!!!!! ${widget.userData}");
    _amountController.clear();
    _sourceController.clear();
    setState(() {
      _isMonthly = false;
    });
  }
}

}
