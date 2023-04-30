import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../pages/guess_page.dart';


get deviceName => Platform.localHostname; // Get the name of the device
final storage = FirebaseStorage.instanceFor(bucket: 'gs://parrot-number-game.appspot.com/');
final storageRef = storage.ref();//bucket is for advanced locating
final gameHistoryRef=storageRef.child("gameHistory/");

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
Future<File> createLocalJsonFile(String fileName,String location, String json) async{
  final path= "${await localPath}/$location/$fileName";
  final file=File(path);
  return file.writeAsString(json);
}

Future<TaskSnapshot> uploadFile(File file,Reference ref,String fileName) async {
  return await ref.child(fileName).putFile(file);
}
Future<TaskSnapshot> downloadToFile(String ref,File file) async{
  final dRef=storageRef.child(ref);
  return await dRef.writeToFile(file);//write to local file
  //taskSnapshot.state:
  // TaskState.running,
  // TaskState.paused,
  // TaskState.success,
  // TaskState.canceled,
  // TaskState.error
}

Future<List<Reference>> dictList(Reference ref) async{
  try{
    final result = await ref.listAll();
    return List.generate(result.items.length, (index) => result.items[index]);
  }
  catch(e)
  {
    return [];
  }
}

