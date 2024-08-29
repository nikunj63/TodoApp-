import 'package:flutter/material.dart';
import 'package:notekeeper/home_screen.dart';

void main (){
  runApp( const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),

      ),
      home: HomeScreen(),
    );
  }
}