import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../pages/guess_page.dart';

get deviceName => Platform.localHostname; // Get the name of the device

final storageRef = FirebaseStorage.instanceFor(bucket: 'gs://parrot-number-game.appspot.com/').ref();//bucket is for advanced locating
final gameHistoryRef=storageRef.child("gameHistory/");
Future<void> firebaseSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();
}

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
Future<File> createLocalJsonFile(String fileName,String location, String json) async{
  final path= "${await localPath}/$location/$fileName";
  final file=File(path);
  return file.writeAsString(json);
}

Future<void> uploadFile(File file,Reference ref,String fileName) async {
  try {
    await ref.child(fileName).putFile(file);
  } catch (e) {
    debugPrint("error: $e");
  }
}
Future<TaskSnapshot> downloadToFile(Reference ref,File file) async{
  return await ref.writeToFile(file);//write to local file
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