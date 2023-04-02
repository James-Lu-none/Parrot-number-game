import 'package:flutter/material.dart';
import 'guess_page.dart';

class ResultPage extends StatelessWidget {
  final List<GameHistory> gameHistoryList;
  final int answer;
  const ResultPage({super.key,required this.gameHistoryList,required this.answer});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Congrats! You won in ${gameHistoryList.length} guess(es):",
              style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
              selectionColor: Colors.green,
            ),
            const SizedBox(height: 5,),
            Text(
              "Answer: $answer",
              style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
              selectionColor: Colors.green,
            ),
            const SizedBox(height: 5,),
            ShowList(gameHistoryList: gameHistoryList,height:350),
            const SizedBox(height: 10,),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/guess');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Colors.green,
                textStyle: const TextStyle(fontSize: 20),
              ),
              icon: const Icon(Icons.refresh,color:Colors.white,size:20),
              label: const Text("refresh"),
            ),

          ],
        )
    )

    );
  }
}

