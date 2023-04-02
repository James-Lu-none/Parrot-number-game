import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            const Image(image:AssetImage("assets/images/flutter.png")),
            const Text('FlutterApp1 - ParrotNumber'),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 100,
              height: 50,
              child:
                ElevatedButton(
                  child: const Text(
                    "start",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                  onPressed: (){
                    Navigator.popAndPushNamed(context, '/guess');
                  },
                ),
            )

          ]
        )
      )
    );
  }
}

