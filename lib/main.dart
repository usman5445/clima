import 'package:clima/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Clima());
}

class Clima extends StatelessWidget {
  const Clima({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
