
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';

import '../Firebase/Firebase_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState()=>_HomePage();
}

class _HomePage extends State<HomePage>{

  Widget _startButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
         backgroundColor: Colors.blue,
      ),
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GuessPage(loadUnfinishedGame: false,)),
        );
      },
      child: const Text(
        "start",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
    );
  }
  Future<void> _checkUnfinishedGame()async {
    bool unfinishedGameFileExist=await File('${await localPath}/unfinishedGame/unfinishedGame.json').exists();
    setState(() {
      if (unfinishedGameFileExist){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GuessPage(loadUnfinishedGame: true)),
        );
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("No unfinished game file"),
            );
          },
        );
      }
    });
  }
  Widget _resumeButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      child: const Text(
        "resume",

        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
      onPressed: ()  {
        _checkUnfinishedGame();
      },
    );
  }
  Widget _recordButton(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange,
      ),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            const Image(image:AssetImage("assets/images/flutter.png")),
            const Text('FlutterApp1 - ParrotNumber'),
            SizedBox(
              width: 300,
              child:ListBody(
                mainAxis: Axis.vertical,
                children:[
                  _startButton(),
                  _resumeButton(),
                  _recordButton(),
                ]
              ),
            )
          ]
        )
      )
    );
  }

}