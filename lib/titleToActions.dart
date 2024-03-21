import 'package:flutter/material.dart';

class PatternLockWidget extends StatefulWidget {
  

  const PatternLockWidget({super.key});

  @override
  _PatternLockWidgetState createState() => _PatternLockWidgetState();
}

class _PatternLockWidgetState extends State<PatternLockWidget> {
  List<Offset> _patternPoints = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          _patternPoints.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (details) {
 
        setState(() {
          _patternPoints.clear();
        });
      },
      child: Container(
        color: Colors.transparent,
        child: CustomPaint(
          painter: PatternPainter(patternPoints: _patternPoints),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final List<Offset> patternPoints;

  PatternPainter({required this.patternPoints});

  @override
  void paint(Canvas canvas, Size size) {
    if (patternPoints.isNotEmpty) {
      Paint paint = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0;

      for (int i = 0; i < patternPoints.length - 1; i++) {
        if (patternPoints[i] != null && patternPoints[i + 1] != null) {
          canvas.drawLine(patternPoints[i], patternPoints[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
