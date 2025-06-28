import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/shared/components.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';

import '../../shared/cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.get(context).doneTasks;
          return tasks.isEmpty
              ? emptyTasksWidget()
              : Container(
                  color: Color(0XFFEFF1FF),
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        buildTaskItem(tasks[index], context, index),
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        //  height: 1.0,
                        color: Colors.grey[300],
                      ),
                    ),
                    itemCount: tasks.length,
                  ),
                );
        });
  }
}
