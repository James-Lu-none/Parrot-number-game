
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parrot_number/pages/result_page.dart';

import '../Firebase/Firebase_storage.dart';
import 'guess_page.dart';
import 'dart:convert';
import 'dart:io';


Future<List<Record>> loadData() async{
  List<Reference> recordRefList=[];
  final List<Record> list=[];
  recordRefList=await dictList(gameHistoryRef);

  if(recordRefList.isEmpty) {
    debugPrint('No record found');
    return [];
  }
  debugPrint("${recordRefList.length} records found");
  for(int i=0;i<recordRefList.length;i++)
  {
    debugPrint("path $i : ${recordRefList[i].fullPath}");
    final tempFile = await File('${await localPath}/tempRecord/${recordRefList[i].name}').create();
    final downloadTask=storage.ref(recordRefList[i].fullPath).writeToFile(tempFile);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
        // TODO: Handle this case.
          break;
        case TaskState.paused:
        // TODO: Handle this case.
          break;
        case TaskState.success:
        // TODO: Handle this case.
          break;
        case TaskState.canceled:
        // TODO: Handle this case.
          break;
        case TaskState.error:
        // TODO: Handle this case.
          break;
      }
    });
    try{
      list.add(Record.fromJson(jsonDecode(await tempFile.readAsString())));
    }
    catch(e)
    {
      print(e);
    }
  }
  debugPrint("${list.length} records loaded");
  return list;
}

class RecordPage extends StatefulWidget{
  const RecordPage({super.key});
  @override
  State<StatefulWidget> createState() =>_RecordPage();
}
class _RecordPage extends State<RecordPage>{
  final Future<List<Record>> _recordList=loadData();
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LeaderBoard",
              style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),
              selectionColor: Colors.green,
            ),
            const SizedBox(height: 5,),
            SizedBox(
              height: 500,
              width: 350,
              child:
              FutureBuilder<List<Record>>(
                  future: _recordList,
                  builder:(BuildContext context, AsyncSnapshot<List<Record>> snapshot)
                  {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[//list of widget here
                        _showRecord(snapshot)
                      ];
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      ];
                    } else {
                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('loading...'),
                        ),
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  }
              )
            ),
            const SizedBox(height: 5,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                _returnButton(),
                _reloadButton(),
              ]
            )
          ],
        )
      )
    );
  }


  Widget _showRecord(AsyncSnapshot<List<Record>> snapshot) {
    List<Record> recordL=snapshot.data!;
    return Flexible(
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
                    recordL.length,
                        (index)=>DataRow(
                        cells: [
                          DataCell(Text(recordL[index].name)),
                          DataCell(Text('${recordL[index].gameHistory.length}')),
                          DataCell(Text(recordL[index].time)),
                        ])
                )
                )
              ],
            )
        )
    );
  }
  Widget _reloadButton(){
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.popAndPushNamed(context, '/record');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:Colors.green,
        textStyle: const TextStyle(fontSize: 20),
      ),
      icon: const Icon(Icons.refresh,color:Colors.white,size:20),
      label: const Text("refresh"),
    );
  }
  Widget _returnButton(){
    return ElevatedButton.icon(
      onPressed: () {
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

}