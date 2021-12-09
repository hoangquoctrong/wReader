import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wreader/Screen/content_screen_read.dart';
import 'package:wreader/Screen/home_screen.dart';
import 'package:wreader/constants/constants.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'wReader',
      theme: ThemeData(
          scaffoldBackgroundColor: Constants.black,
          brightness: Brightness.dark),
      home: HomeScreen(),
    );
  }
}
