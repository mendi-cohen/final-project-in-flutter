
import 'package:flutter/material.dart';




//////  כרטיסי הכניסה הראשית 


class EnterCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
 

  const EnterCard({
    super.key,
    required this.title,
    required this.onTap,
   
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           const SizedBox(height: 30 , width: 20,),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              
            ),
          ],
        ),
      ),
    );
  }
}


///// כרטיסי העמוד הראשי


class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
 

  const OptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
   
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: Colors.blue,
            ),
           const SizedBox(height: 15 , width: 180,),
            Text(
              title,
              style: const TextStyle(fontSize: 16 ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}




