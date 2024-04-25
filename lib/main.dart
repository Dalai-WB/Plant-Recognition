import 'package:flutter/material.dart';
import 'package:plant_recognition/consts/color_const.dart';
import 'package:plant_recognition/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DGreen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: appGrey,
        colorScheme: ColorScheme.fromSeed(seedColor: defaultGreen),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}