import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math' as math;
import 'package:throwing_zone/Login.dart';
import 'test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(KnifeThrowingGame());
}

class KnifeThrowingGame extends StatefulWidget {
  @override
  _KnifeThrowingGameState createState() => _KnifeThrowingGameState();
}

class _KnifeThrowingGameState extends State<KnifeThrowingGame> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  HomePageWidget(),
    );
  }
}