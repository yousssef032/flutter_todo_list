import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_task_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  Database? database;
  List<Map> newTasks = [];
  List<Map> archivedTasks = [];
  List<Map> doneTasks = [];
  String selectedPriority = 'Normal';
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTaskScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'To Do List',
    'Done',
    'Archived',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) async {
        await database
            .execute(
                //id integer
                //title string
                //date string
                //time string
                //status string
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT , priority TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error when creating table: ${error.toString()}');
        });

        print('Database created');
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    }).catchError((error) {
      print('Error when creating database: ${error.toString()}');
    });
  }

  insertToDatabase(
    @required String title,
    @required String date,
    @required String time,
    @required String priority,
  ) async {
    await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title ,date ,time ,status,priority)VALUES ("$title","$date","$time","new" ,"$priority")')
          .then((value) {
        print('inserted successfully: $value');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      });
    }).catchError((error) {
      print('Error when inserting new record: ${error.toString()}');
    });
  }

  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDatabaseLoadingState());
    database?.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState({
    required bool Show,
    required IconData icon,
  }) {
    isBottomSheetShown = Show;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database?.rawUpdate('UPDATE tasks SET status = ?  WHERE id = ?', [
      '$status',
      '$id',
    ]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database
        ?.rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
