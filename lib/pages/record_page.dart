
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parrot_number/pages/result_page.dart';

import '../Firebase/Firebase_storage.dart';
import 'guess_page.dart';
import 'dart:convert';
import 'dart:io';


class RecordPage extends StatefulWidget{
  const RecordPage({super.key});
  @override
  State<StatefulWidget> createState() =>_RecordPage();
}
class _RecordPage extends State<RecordPage>{
  List<Reference> recordRefList=[];
  List<Record> recordList=[];
  @override
  void initState(){
    super.initState();
    loadData();
  }
  Widget _reloadButton(){
    return ElevatedButton(
      child: const Text(
        "start",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
      ),
      onPressed: (){
        loadData();
      },
    );
  }
  void loadData() async{
    recordRefList=await dictList(gameHistoryRef);
    debugPrint("$recordRefList");
    if(recordRefList.isEmpty)return;
    for(int i=0;i<recordRefList.length;i++)
    {
      final tempFile = File('${await localPath}/tempRecord/${recordRefList[i].name}');
      storage.ref(recordRefList[i].fullPath).writeToFile(tempFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Leaderboard'),
            _reloadButton()
          ],
        )
      )
    );
  }
}