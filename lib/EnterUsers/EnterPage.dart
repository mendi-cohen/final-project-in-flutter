import 'package:flutter/material.dart';
import 'Log-in.dart';
import './Sign-in.dart';



class EnterPage extends StatefulWidget{
 const EnterPage ({super.key});
  @override
State<EnterPage> createState ()=> _EnterState();
}


class _EnterState extends State<EnterPage>{
    bool _isLoginFormVisible = false;
  @override

Widget build (BuildContext context){
  return Scaffold(
    appBar: AppBar(title: const Center(child:Text(" אפליקציית חסכוני בעצמי ",))),
       body: Center(
        child: Container(
          width: 400,
            decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://www.mynet.co.il/picserver/mynet/crop_images/2023/06/28/BkGnQuYd3/BkGnQuYd3_0_0_800_1000_0_large.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationForm()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "הרשמה",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
                          Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoginFormVisible = !_isLoginFormVisible;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    elevation: 5,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "כניסה",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: _isLoginFormVisible ? MediaQuery.of(context).size.height * 0.3 : 0,
                color: Colors.blue,
                child: Center(
                  child:LoginPage()
                ),
              ),
            ],
          ),
        ),
      ),
  );
}
}