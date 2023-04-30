
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
    return ElevatedButton.icon(
      onPressed: () {
        loadData();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.green,
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: const Icon(Icons.refresh,color:Colors.white,size:20),
      label: const Text("refresh"),
    );
  }
  void loadData() async{
    recordList=[];
    recordRefList=await dictList(gameHistoryRef);
    debugPrint("$recordRefList");
    if(recordRefList.isEmpty) {
      debugPrint('No record found');
      return;
    }
    debugPrint("${recordRefList.length} records found");
    for(int i=0;i<recordRefList.length;i++)
    {
      final tempFile = File('${await localPath}/tempRecord/${recordRefList[i].name}');
      storage.ref(recordRefList[i].fullPath).writeToFile(tempFile);
      recordList.add(Record.fromJson(jsonDecode(await tempFile.readAsString())));
    }
    debugPrint("${recordList.length} records loaded");
    debugPrint("${recordList[0]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "LeaderBoard",
                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
                  selectionColor: Colors.green,
                ),
                const SizedBox(width: 5,),
                _reloadButton()
              ],
            ),
            const SizedBox(height: 5,),
            Flexible(
              flex: 1,
              child:
              SizedBox(
                height: 500,
                width: 350,
                child:
                  ListView(
                    children: [
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('try')),
                          DataColumn(label: Text('time'))
                        ]
                        , rows: List<DataRow>.generate(
                          recordList.length,
                          (index)=>DataRow(
                           cells: [
                             DataCell(Text(recordList[index].name)),
                             DataCell(Text('${recordList[index].gameHistory.length}')),
                             DataCell(Text(recordList[index].time)),
                           ])
                        )
                      )
                    ],
                  )
              )
            )
          ],
        )
      )
    );
  }
}