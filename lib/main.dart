import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';
import 'package:parrot_number/pages/home_page.dart';
import 'package:parrot_number/pages/record_page.dart';
import 'package:path_provider/path_provider.dart';
import 'Firebase/Firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String local= await localPath;
  String directoryPath = '$local/lists';
  String tempRecordPath = '$local/tempRecord';
  String unfinishedGamePath = '$local/unfinishedGame';

  Directory(directoryPath).createSync();
  Directory(tempRecordPath).createSync();
  Directory(unfinishedGamePath).createSync();
  //Directory(directoryPath).delete(recursive: true);

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
          '/record' : (context) =>const RecordPage(),
        },
      );
}
