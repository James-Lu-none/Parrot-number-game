import 'package:flutter/material.dart';
import 'package:parrot_number/pages/guess_page.dart';
import 'package:parrot_number/pages/home_page.dart';

void main() {
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
