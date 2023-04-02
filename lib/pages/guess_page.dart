import 'dart:math';
import 'package:flutter/material.dart';

class GenGame
{
  int lowerNumber=1;
  int upperNumber=100;
  final answer = Random().nextInt(99)+1;
}
class _GuessPage extends State<GuessPage>{
  GenGame game=GenGame();
  final TextEditingController myController = TextEditingController();
  void _updateValue(String value)
  {
    setState(() {
      int iValue;
      try {
        iValue = int.parse(value);
      }
      catch (e) {
        debugPrint(e as String?);
        return;
      }
      debugPrint("num: $iValue");
      if (iValue < game.answer && iValue >= game.lowerNumber) {
        game.lowerNumber = iValue;
        debugPrint("lowerNumber updated=${game.lowerNumber}");
      }
      else if (iValue > game.answer && iValue <= game.upperNumber) {
        game.upperNumber = iValue;
        debugPrint("upperNumber updated=${game.upperNumber}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:Center(
            child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const Text(
                    'Guess a number between',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 20),
                  ),
                  Text.rich(
                    TextSpan(
                      children:<TextSpan> [//Q: statement '<TextSpan>' needed?
                        TextSpan(
                          text:'${game.lowerNumber}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        ),
                        const TextSpan(
                          text:' and ',
                        ),
                        TextSpan(
                          text:'${game.upperNumber}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),
                  ),

                  SizedBox(
                      height: 100,
                      width:300,
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            SizedBox(
                              height: 50,
                              width:200,
                              child:
                              TextField(
                                controller: myController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter a num',

                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:Stack(
                                    children:[
                                      TextButton(
                                        onPressed: () {
                                          _updateValue(myController.text);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:Colors.blue,
                                          padding: const EdgeInsets.all(16.0),
                                          textStyle: const TextStyle(fontSize: 20),
                                        ),
                                        child: const Icon(Icons.arrow_back,color:Colors.white,size:20),
                                      ),
                                    ]
                                )
                            ),
                          ]
                      )
                  ),
                  Text("Answer is ${game.answer}"),
                ]
            )
        )
    );
  }
}

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});
  @override
  State<StatefulWidget> createState() =>_GuessPage();
}
