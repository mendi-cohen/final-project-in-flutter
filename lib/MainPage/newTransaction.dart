import 'package:flutter/material.dart';

class IncomeEntryWidget extends StatefulWidget {
  @override
  _IncomeEntryWidgetState createState() => _IncomeEntryWidgetState();
}

class _IncomeEntryWidgetState extends State<IncomeEntryWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  bool _isMonthly = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              // כאן נוסיף פונקציה שתעביר את הנתונים לדטה בייס
              _submitDataToDatabase();
            },
            child: Text('הכנס '),
          ),
        ],
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

  void _submitDataToDatabase() {
    // כאן יש להוסיף את הפונקציה שתעביר את הנתונים לדטה בייס
    // לדוגמה:
    final amount = double.parse(_amountController.text);
    final source = _sourceController.text;
    final isMonthly = _isMonthly;

    // כאן יש להעביר את הנתונים לדטה בייס
    // לדוגמה:
    // DatabaseService.submitIncomeData(amount, source, isMonthly);

    // אחרי העברת הנתונים, ניתן לאפס את השדות
    _amountController.clear();
    _sourceController.clear();
    setState(() {
      _isMonthly = false;
    });
  }
}
