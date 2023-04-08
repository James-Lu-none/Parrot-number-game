import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Firebase/Firebase_storage.dart';
import 'guess_page.dart';


class ResultPage extends StatefulWidget{
  final List<GameHistory> gameHistoryList;
  final int answer;
  const ResultPage({super.key,required this.gameHistoryList,required this.answer});
  @override
  State<StatefulWidget> createState()=>_ResultPage();
}
class _ResultPage extends State<ResultPage> {
  List<GameHistory> gameHistoryList = [];
  int answer = 0;
  TextEditingController userInputNameController=TextEditingController();
  String name='';
  @override
  void initState() {
    super.initState();
    name='';
    gameHistoryList = widget.gameHistoryList;
    answer = widget.answer;
  }
  @override
  void dispose(){
    userInputNameController.dispose();
    super.dispose();
  }

  Future <String?> _openEnterNameDialog(){
    return showDialog<String>(
        context: context,
        builder: (context)=>AlertDialog(
          title: const Text("Enter your name"),
          content:TextField(
            autofocus: true,
            controller: userInputNameController,
            decoration: const InputDecoration(hintText: 'name here'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(userInputNameController.text);
                userInputNameController.clear();
              },
              child:const Text('SUBMIT'),
            )

          ],
        )
    );
  }
  Future<void> _uploadFile() async {
    try{
      String fileTitle="${deviceName}_${DateTime.now().millisecondsSinceEpoch}";
      Record record=Record(name, gameHistoryList);
      String json=jsonEncode(record);
      debugPrint(json);
      File f=await createLocalJsonFile('$fileTitle.json', 'lists', json);//save
      uploadFile(f,gameHistoryRef,'$fileTitle.json');//upload
    }
    catch(e){
      debugPrint("upload Error here: $e");
    }
  }
  Widget _uploadButton(){
    return ElevatedButton.icon(
      onPressed: () async{
        final inputName = await _openEnterNameDialog();
        setState((){
          name=inputName!;
        });
        _uploadFile();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.orange,
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: const Icon(Icons.upload,color:Colors.white,size:20),
      label: const Text("upload your record"),
    );
  }
  Widget _refreshButton(){
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.popAndPushNamed(context, '/guess');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.green,
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: const Icon(Icons.refresh,color:Colors.white,size:20),
      label: const Text("refresh"),
    );
  }
  Widget _congratsText(){
    return Text(
      "Congrats! You won in ${gameHistoryList.length} guess(es):",
      style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
      selectionColor: Colors.green,
    );
  }
  Widget _showAnswer(){
    return Text(
      "Answer: $answer",
      style: const TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
      selectionColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _congratsText(),
            const SizedBox(height: 5,),
            _showAnswer(),
            const SizedBox(height: 5,),
            ShowList(gameHistoryList: gameHistoryList,height:350),
            _uploadButton(),
            const SizedBox(height: 10,),
            _refreshButton(),
          ],
        )
      )

    );
  }
}

