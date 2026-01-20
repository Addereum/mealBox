import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class MealBoxApp extends StatelessWidget {
  const MealBoxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealBox',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}