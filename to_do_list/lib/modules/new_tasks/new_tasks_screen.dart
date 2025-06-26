import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/shared/components.dart';
import 'package:to_do_list/shared/constants.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';
import 'package:to_do_list/shared/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).newTasks;
          return tasks.isEmpty
              ? emptyTasksWidget()
              : ListView.separated(
                  itemBuilder: (context, index) =>
                      buildTaskItem(tasks[index], context),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 20.0,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemCount: tasks.length,
                );
        });
  }
}
