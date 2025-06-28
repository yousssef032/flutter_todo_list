import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/shared/components.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';

//1.create database
//2.create table
//3. open database
//4.insert into database
//5. read from database
//6. update database
//7. delete from database
class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var priorityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            if (AppCubit.get(context).isBottomSheetShown) {
              Navigator.pop(context);
            }
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Color(0XFFEFF1FF),
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  fontSize: 22.0,
                  color: Color(0XFF2B3031),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              leading: Icon(Icons.menu, color: Colors.black, size: 30.0),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.notifications_rounded,
                    color: Colors.grey[800],
                    size: 30.0,
                  ),
                ),
              ],
            ),
            body: state is AppGetDatabaseLoadingState
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )
                : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState?.validate() ?? false) {
                    cubit.insertToDatabase(
                      titleController.text,
                      dateController.text,
                      timeController.text,
                      cubit.selectedPriority,
                    );
                  } else {}
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        elevation: 20.0,
                        (context) => Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
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
                                SizedBox(
                                  height: 15.0,
                                ),
                                DropdownButtonFormField<String>(
                                  value: cubit.selectedPriority,
                                  decoration: InputDecoration(
                                    labelText: 'Priority',
                                    prefixIcon: Icon(Icons.flag),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: ['High', 'Normal', 'Low']
                                      .map((priority) =>
                                          DropdownMenuItem<String>(
                                            value: priority,
                                            child: Text(priority),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      cubit.selectedPriority = value;
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a priority';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      Show: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    Show: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              selectedItemColor: Colors.black,
              onTap: (index) {
                cubit.changeIndex(index);
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
        },
      ),
    );
  }

  Future<String> getName() async {
    return 'Ahmed Ali';
  }
}
