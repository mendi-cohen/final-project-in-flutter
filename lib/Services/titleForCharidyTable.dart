// ignore_for_file: use_build_context_synchronously, unnecessary_cast

import 'package:flutter/material.dart';

class TitleForCharidyTable extends StatelessWidget {
  final String title;
  final Color color ;
  const TitleForCharidyTable({super.key ,required this.title , this.color =const Color.fromARGB(255, 138, 170, 20)});
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10), 
        ),
        child:  Padding(
          padding: const EdgeInsets.all(8.0), 
          child: Text(
           title,
            style:const  TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
