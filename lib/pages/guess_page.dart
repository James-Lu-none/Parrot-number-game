import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parrot_number/pages/result_page.dart';

import '../Firebase/Firebase_storage.dart';


class UnfinishedGame{
  final GenGame game;
  List<GameHistory> gameHistory=[];//??? List<GameHistory> gameHistory;

  factory UnfinishedGame(game,gameHistory){
    final unfinishedGame=UnfinishedGame._internal(game, gameHistory);
    return unfinishedGame;
  }
  UnfinishedGame._internal(this.game,this.gameHistory);
  
  factory UnfinishedGame.fromJson(dynamic json){
    List gameHistoryObj =json['gameHistory'];
    List<GameHistory> gameHistories = gameHistoryObj.map((gameHistoryJson) => GameHistory.fromJson(gameHistoryJson)).toList();
    return UnfinishedGame(GenGame.fromJson(json['game']), gameHistories);
  }

  Map toJson() {
    List<Map<String,dynamic>> gameHistory = this.gameHistory.map((i) => i.toJson()).toList();
    return {
      'game': game,
      'gameHistory': gameHistory
    };
  }

  @override
  String toString() {
    return '{ $game, $gameHistory }';
  }
}
class Record{
  final String name;
  final String time;
  List<GameHistory> gameHistory=[];//??? final List<GameHistory> gameHistory;
  Record(this.name,this.time, this.gameHistory);

  factory Record.fromJson(dynamic json){
      List gameHistoryObj =json['gameHistory'];
      List<GameHistory> gameHistories = gameHistoryObj.map((gameHistoryJson) => GameHistory.fromJson(gameHistoryJson)).toList();

      return Record(json['name'] as String, json['time'] as String, gameHistories);
  }


  Map toJson() {
    List<Map<String,dynamic>> gameHistory = this.gameHistory.map((i) => i.toJson()).toList();
    return {
      'name': name,
      'time': time,
      'gameHistory': gameHistory
    };
  }

  @override
  String toString() {
    return '{ $name, $time, $gameHistory }';
  }
}
class GameHistory
{
  int guessNumber;
  String statement;

  GameHistory(this.guessNumber,this.statement);

  factory GameHistory.fromJson(dynamic json){
    return GameHistory(json['guessNumber'] as int, json['statement'] as String);
  }


  Map<String, dynamic> toJson() => {
    'guessNumber': guessNumber,
    'statement': statement,
  };

  @override
  String toString() {
    return '{ $guessNumber, $statement }';
  }
}

class GenGame
{
  int lowerNumber;
  int upperNumber;
  final int answer;
  GenGame(this.lowerNumber,this.upperNumber,this.answer);

  factory GenGame.fromJson(dynamic json){
    return GenGame(json['lowerNumber'] as int,json['upperNumber'] as int,json['answer'] as int);
  }
  Map<String, dynamic> toJson() => {
    'lowerNumber': lowerNumber,
    'upperNumber': upperNumber,
    'answer': answer,
  };
  @override
  String toString() {
    return '{ $lowerNumber, $upperNumber, $answer  }';
  }
}

class GuessPage extends StatefulWidget {
  final bool loadUnfinishedGame;
  const GuessPage({super.key,required this.loadUnfinishedGame});
  @override
  State<StatefulWidget> createState() =>_GuessPage();
}

class _GuessPage extends State<GuessPage>{
  List<GameHistory> gameHistoryList=[];
  GenGame game=GenGame(1,100,Random().nextInt(99)+1);
  TextEditingController userInputNumController=TextEditingController();
  @override
  void initState(){
    super.initState();
    if(widget.loadUnfinishedGame) _loadUnfinishedGame();
    userInputNumController = TextEditingController();
  }
  void _updateValue(String value){
    setState(() {
      int iValue;
      try {
        iValue = int.parse(value);
      }
      catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("invalid input: integer parse failed"),
            );
          },
        );
        return;
      }
      debugPrint("num: $iValue");
      if (iValue < game.answer && iValue > game.lowerNumber) {
        game.lowerNumber = iValue;
        gameHistoryList.add(GameHistory(iValue,"lower"));
        debugPrint("lowerNumber updated=${game.lowerNumber}");
      }
      else if (iValue > game.answer && iValue < game.upperNumber) {
        game.upperNumber = iValue;
        gameHistoryList.add(GameHistory(iValue,"greater"));
        debugPrint("upperNumber updated=${game.upperNumber}");
      }
      else if(iValue==game.answer){
        gameHistoryList.add(GameHistory(iValue,"equal"));
        _gameOver();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>ResultPage(gameHistoryList:gameHistoryList,answer: game.answer,))
        );
      }
      else{
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("invalid input: out of range"),
            );
          },
        );
      }
    });
  }
  Widget _gameTitle() {
    return const Text(
      'Guess a number between',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
    );
  }
  Widget _numberInterval(){
    return Text.rich(
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
    );
  }
  Widget _inputField(){
    return TextField(
      controller: userInputNumController,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a num',
      ),
    );
  }
  Widget _confirmInputButton(){
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:Stack(
            children:[
              TextButton(
                onPressed: () {
                  _updateValue(userInputNumController.text);
                  userInputNumController.clear();
                },
                style: TextButton.styleFrom(
                  backgroundColor:Colors.blue,
                  padding: const EdgeInsets.all(15.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Icon(Icons.arrow_back,color:Colors.white,size:20),
              ),
            ]
        )
    );
  }
  Widget _returnButton(){
    return ElevatedButton.icon(
      onPressed: (){
        _saveUnfinishedGame();
        Navigator.popAndPushNamed(context, '/');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.blue,
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: const Icon(Icons.arrow_back_outlined,color:Colors.white,size:20),
      label: const Text("return"),
    );
  }
  Future<void> _saveUnfinishedGame() async {
    UnfinishedGame unfinishedGame=UnfinishedGame(game,gameHistoryList);
    String json=jsonEncode(unfinishedGame);
    await createLocalJsonFile('unfinishedGame.json', 'unfinishedGame', json);
    debugPrint("file saved");
  }
  Future<void> _loadUnfinishedGame() async{
    //no unfinished game file error handling
    final tempFile = File('${await localPath}/unfinishedGame/unfinishedGame.json');
    final unfinishedGame = UnfinishedGame.fromJson(jsonDecode(await tempFile.readAsString()));
    setState((){
      game = unfinishedGame.game;
      gameHistoryList = unfinishedGame.gameHistory;
    });
  }
  Future<void> _gameOver()async {
    bool unfinishedGameFileExist=await File('${await localPath}/unfinishedGame/unfinishedGame.json').exists();
    if(unfinishedGameFileExist)File('${await localPath}/unfinishedGame/unfinishedGame.json').delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            _gameTitle(),
            _numberInterval(),
            SizedBox(
              height: 100,
              width:300,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  SizedBox(
                    width:200,
                    child:_inputField()
                  ),
                  const SizedBox(width: 10),
                  _confirmInputButton(),
                ]
              )
            ),
            _returnButton(),
            Text("The Answer is ${game.answer}",style: const TextStyle(fontSize: 10)),
            if(gameHistoryList.isNotEmpty)ShowList(gameHistoryList: gameHistoryList,height: 200),
          ]
        )
      )
    );
  }
}




class ShowList extends StatelessWidget{
  final List<GameHistory> gameHistoryList;
  final double height;
  const ShowList({super.key, required this.gameHistoryList,required this.height});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child:
      SizedBox(
        height: height,
        width: 350,
        child:
        ListView(
          children:[
            DataTable(
              columns: const [
                DataColumn(label: Text('No.')),
                DataColumn(label: Text('number')),
                DataColumn(label: Text('statement'))
              ],rows:List<DataRow>.generate(
                gameHistoryList.length,
                (index) => DataRow(
                cells: [
                  DataCell(Text('${index+1}')),
                  DataCell(Text('${gameHistoryList[index].guessNumber}')),
                  DataCell(Text(gameHistoryList[index].statement)),
                ])
              ),
            )
          ]
        ),
      ),
    );
  }
}


