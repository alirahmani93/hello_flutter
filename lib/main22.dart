// main.dart
import 'package:flutter/material.dart';
// import 'package:src/screens/card_list_screen.dart';
import 'package:sampleapp/src/screen/card_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CardListScreen(),
    );
  }
}
