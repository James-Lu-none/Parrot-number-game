import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../Firebase/Firebase_storage.dart';
import '../main.dart';
import 'guess_page.dart';
import 'package:intl/intl.dart';

class ResultPage extends StatefulWidget{
  final List<GameHistory> gameHistoryList;
  final int answer;
  const ResultPage({super.key,required this.gameHistoryList,required this.answer});
  @override
  State<StatefulWidget> createState()=>_ResultPage();
}
class _ResultPage extends State<ResultPage> {
  List<GameHistory> gameHistoryList = [];
  bool uploaded=false;
  int answer = 0;
  TextEditingController userInputNameController=TextEditingController();
  String name='';

  @override
  void initState() {
    super.initState();
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
    final DateTime time=DateTime.now();
    final String gmt=(time.timeZoneOffset.inHours.isNegative)?"${time.timeZoneOffset.inHours}":"+${time.timeZoneOffset.inHours}";
    final String formattedTime ="${DateFormat('yyyy/MM/dd kk:mm:ss').format(time)} (GMT$gmt)" ;
    final String fileTitle="${deviceName}_${time.millisecondsSinceEpoch}";

    Record record=Record(name,formattedTime, gameHistoryList);
    String json=jsonEncode(record);
    debugPrint(json);
    File tempFile=await createLocalJsonFile('$fileTitle.json', 'lists', json);//save
    final uploadTask = gameHistoryRef.child('$fileTitle.json').putFile(tempFile);
    debugPrint("start uploading");
    tempFile.delete();//optional
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          debugPrint("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          debugPrint("Upload is paused.");
          break;
        case TaskState.canceled:
          debugPrint("Upload was canceled");
          break;
        case TaskState.error:
          debugPrint("upload failed");
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text("upload failed"),
              );
            },
          );
          break;
        case TaskState.success:
          debugPrint("upload complete");
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text("upload completed"),
              );
            },
          );
          setState((){
            uploaded=true;
          });
          break;
      }
    });
    //return uploadFile(f,gameHistoryRef,'$fileTitle.json');//upload
  }
  Widget _homeButton(){
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>const ParrotNumberApp())
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.blue,
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: const Icon(Icons.home,color:Colors.white,size:20),
      label: const Text("Home"),
    );
  }
  Widget _uploadButton(){
    return ElevatedButton.icon(
      onPressed: () async{
        final inputName = await _openEnterNameDialog();
        setState((){
          name=inputName!;
          uploaded=true;
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

            _homeButton(),
            const SizedBox(height: 10,),
            if(!uploaded)_uploadButton(),
            const SizedBox(height: 10,),
            _refreshButton(),

          ],
        )
      )
    );
  }
}


