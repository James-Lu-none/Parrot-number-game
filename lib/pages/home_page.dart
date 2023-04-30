import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState()=>_HomePage();
}

class _HomePage extends State<HomePage>{
  Widget _resumeButton(){
    return ElevatedButton(
      child: const Text(
        "resume",

        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
      onPressed: (){
        ///TODO:load unfinished game here
        //Navigator.push(
        //    context,
        //    MaterialPageRoute(builder: (context)=>guessPage(gameHistoryList:gameHistoryList,answer: game.answer,))
        //);
      },
    );
  }
  Widget _recordButton(){
    return ElevatedButton(
      child: const Text(
        "Leaderboard",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
      onPressed: (){
        Navigator.popAndPushNamed(context, '/record');
      },
    );
  }
  Widget _startButton(){
    return ElevatedButton(
      child: const Text(
        "start",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
      onPressed: (){
        Navigator.popAndPushNamed(context, '/guess');
      },
    );
  }

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
                    _startButton(),
                  ),
                  const SizedBox(height:10),
                  SizedBox(
                      width: 200,
                      height: 50,
                      child:
                      _recordButton(),
                  ),
                  _resumeButton(),
                ]
            )
        )
    );
  }

}