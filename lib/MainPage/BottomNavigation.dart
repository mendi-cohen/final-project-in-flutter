import 'package:flutter/material.dart';


class BottomNavigationDemo extends StatefulWidget {
  final Map<String, dynamic> userData;
  final  Widget one;
  final  Widget two;
  final  Widget ?three;
  const BottomNavigationDemo({super.key, required this.userData , required this.one , required this.two ,this.three,}) ;

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
      widget.one,
      widget.two,
      if (widget.three != null) widget.three!,

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
        items:  <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ' פעילות חודשית ',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'סיכום שנתי',
          ),
          if (widget.three != null)
            const BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label:  'סיכום תרומות חודשי',
            ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
