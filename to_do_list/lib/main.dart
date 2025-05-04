import 'package:flutter/material.dart';
import 'package:to_do_list/layout/home_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          //useMaterial3: false,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.blue, foregroundColor: Colors.white),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white, selectedItemColor: Colors.blue)),
      home: const HomeLayout(),
    );
  }
}
