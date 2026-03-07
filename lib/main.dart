import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(IBPSApp());
}

class IBPSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IBPS Prep',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}