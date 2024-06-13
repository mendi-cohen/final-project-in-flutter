import 'package:flutter/material.dart';

////// כרטיסי הכניסה הראשית
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
        elevation: 4, // צל
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

////// כרטיסי העמוד הראשי
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
        color: const Color.fromARGB(255, 194, 221, 44),
        margin: const EdgeInsets.all(10),
        elevation: 4, 
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color:const Color.fromARGB(255, 16, 16, 13),
              ),
              const SizedBox(height: 15 , width: 155,),
              Text(
                title,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
