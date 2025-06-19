import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/shared/components.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

//1.create database
//2.create table
//3. open database
//4.insert into database
//5. read from database
//6. update database
//7. delete from database

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTaskScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'Tasks',
    'Done Tasks',
    'Archived Takss',
  ];
  Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState?.validate() ?? false) {
              insertToDatabase(
                titleController.text,
                dateController.text,
                timeController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            } else {}
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
                  elevation: 20.0,
                  (context) => Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            label: 'Task Title',
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Title must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.title,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            label: 'Task Time',
                            controller: timeController,
                            type: TextInputType.datetime,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then(
                                (value) {
                                  if (value != null) {
                                    timeController.text =
                                        value.format(context).toString();
                                  }
                                },
                              );
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Time must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.watch_later_rounded,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          defaultFormField(
                            label: 'Task Date',
                            controller: dateController,
                            type: TextInputType.datetime,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 365 * 2)))
                                  .then((value) {
                                if (value != null) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value);
                                }
                              });
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            prefix: Icons.calendar_month_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task,
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
            ),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'Archived',
          )
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'Ahmed Ali';
  }

  void createDatabase() async {
    database = await openDatabase(
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
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('Table created');
        }).catchError((error) {
          print('Error when creating table: ${error.toString()}');
        });

        print('Database created');
      },
      onOpen: (database) {
        print('Database opened');
      },
    );
  }

  Future insertToDatabase(
    @required String title,
    @required String date,
    @required String time,
  ) async {
    return await database?.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title ,date ,time ,status)VALUES ($title,$date,$time,"new" )')
          .then((value) {
        print('inserted successfully with id: $value');
      }).catchError((error) {
        print('Error when inserting new record: ${error.toString()}');
      });
    });
  }
}
