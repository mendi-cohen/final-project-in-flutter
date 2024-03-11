import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Widget'),
      ),
      body: Center(
        child: CustomPaint(
          size: Size(400, 400),
          painter: MyCustomPainter(),
        ),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 217, 255, 0)!  // Brighter color for the fill
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3; // Increased radius for wider coin edge

    canvas.drawCircle(center, radius, paint);

    final shadowPaint = Paint()
      ..color = Colors.yellow! // Darker color for the stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18.0; // Increased stroke width for a thicker edge

    final shadowCenter = Offset(size.width / 2 + 2, size.height / 2 + 2);
    canvas.drawCircle(shadowCenter, radius, shadowPaint);

    // Add text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Thrifty myself',
        style: TextStyle(
          fontSize: 26.0,
          color: Colors.brown[900], // Darker color for the text
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
