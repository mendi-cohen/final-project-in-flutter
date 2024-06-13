import 'package:flutter/material.dart';

class TextAnimationWidget extends StatefulWidget {
  final String title;
  final double fontSize; // פרמטר נוסף לגודל הפונט
  TextAnimationWidget({Key? key, required this.title, this.fontSize = 35.0}) : super(key: key);
  
  @override
  _TextAnimationWidgetState createState() => _TextAnimationWidgetState();
}

class _TextAnimationWidgetState extends State<TextAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(221, 147, 78, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), 
              ),
            ],
          ),
          
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white), // שימוש בפרמטר החדש שנוסף לגודל הפונט
          ),
        ),
      ),
    );
  }
}
