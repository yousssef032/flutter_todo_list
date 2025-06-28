import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_list/layout/home_layout.dart';
import 'package:to_do_list/shared/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Important line

  Bloc.observer = MyBlocObserver();
  //await deleteDatabaseFile(); // Uncomment this line to delete the database file on app start
  runApp(const MyApp());
}

Future<void> deleteDatabaseFile() async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'todo.db');
  await deleteDatabase(path);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //     primarySwatch: Colors.blue,
      //     //useMaterial3: false,
      //     appBarTheme: AppBarTheme(
      //         backgroundColor: Colors.blue, foregroundColor: Colors.white),
      //     floatingActionButtonTheme: FloatingActionButtonThemeData(
      //         backgroundColor: Colors.blue, foregroundColor: Colors.white),
      //     bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //         backgroundColor: Colors.white, selectedItemColor: Colors.blue)),
      home: HomeLayout(),
    );
  }
}
