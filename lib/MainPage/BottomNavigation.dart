import 'package:flutter/material.dart';
import './charidy.dart';
import './CharidyTable.dart';

class BottomNavigationDemo extends StatefulWidget {
  final Map<String, dynamic> userData;
  const BottomNavigationDemo({super.key, required this.userData}) ;

  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      CharidyWidget(userData: widget.userData),
      CharidyTableWidget(userData: widget.userData),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'פעילות הצדקה',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'סיכום חודשי',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
