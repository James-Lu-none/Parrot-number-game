import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';
import 'package:parrot_number/pages/home_page.dart';
import 'Firebase/Firebase_storage.dart';
import 'package:intl/intl.dart';


Future<void> main() async {
  debugPrint("time: ${deviceName}_${DateTime.now().millisecondsSinceEpoch}");
  firebaseSetup();
  /*
  DateTime time=DateTime.now();
  String formattedDate = DateFormat('yyyyMMdd_kkmmss').format(time);
  debugPrint(formattedDate);

  Directory('${await localPath}/lists').createSync();
  const List<GameHistory> testData=[
    GameHistory(23,"lower"),
    GameHistory(25,"lower"),
    GameHistory(16,"greater"),
    GameHistory(84,"greater"),
    GameHistory(50,"equal"),
  ];

  String json=jsonEncode(testData);//encode
  File f=await createLocalJsonFile('$formattedDate.json', 'lists', json);//save
  uploadFile(f,gameHistoryRef,'$formattedDate.json');//upload

  final result=await dictList(gameHistoryRef);//find all dictiories
  debugPrint("$result");

  final file2 = File('${await localPath}/1.json');
  final a=await downloadToFile(result[0], file2);
*/
  runApp(const ParrotNumberApp());
}

class ParrotNumberApp extends StatelessWidget {
  const ParrotNumberApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Parrot Number',
        theme: ThemeData(brightness:Brightness.light,primaryColor: Colors.lightBlue),
        initialRoute: '/',
        routes:{
          '/': (context) =>const HomePage(),
          '/guess' : (context) =>const GuessPage(),
        },
      );
}
