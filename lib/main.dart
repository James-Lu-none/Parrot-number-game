import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';
import 'package:parrot_number/pages/home_page.dart';
import 'Firebase/Firebase_storage.dart';

Future<void> main() async {
  firebaseSetup();
  Directory('${await localPath}/lists').createSync();
  const List<GameHistory> testData=[
    GameHistory(23,"lower"),
    GameHistory(25,"lower"),
    GameHistory(16,"greater"),
    GameHistory(84,"greater"),
    GameHistory(50,"equal"),
  ];
  String json=jsonEncode(testData);
  debugPrint(json);
  File f=await createLocalJsonFile('test1.json', 'lists', json);
  uploadFile(f,gameHistoryRef,'test1.json');
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
