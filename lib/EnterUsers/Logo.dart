import 'package:flutter/material.dart';

class GoldCoin extends StatelessWidget {
  final double size;

  const GoldCoin({Key? key, this.size = 50.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.yellow[800]!,
            Colors.yellow[600]!,
            Colors.yellow[400]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.8,
          height: size * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow[700],
            border: Border.all(
              color: Colors.yellow[900]!,
              width: 3,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Thrifty',
                style: TextStyle(
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Montserrat',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 1
                    ..color = Colors.black,
                ),
              ),
              Text(
                'myself',
                style: TextStyle(
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Montserrat',
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3
                    ..color = Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
