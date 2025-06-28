import 'package:flutter/material.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixPressed,
  String? Function(String?)? validate,
  bool isClickable = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    enabled: isClickable,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(icon: Icon(suffix), onPressed: suffixPressed)
          : null,
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context, index) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          AppCubit.get(context).updateData(
            status: 'done',
            id: model['id'],
          );
        } else if (direction == DismissDirection.endToStart) {
          AppCubit.get(context).deleteData(id: model['id']);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            border: Border.all(
              width: 2.0,
              style: BorderStyle.solid,
              color: Colors.grey[400]!,
            ),
            color: index == 0 ? Color(0xFFF8C64DF) : Color(0xFFECEDFF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: 40.0,
                //   child: Text(
                //     '${model['time']}',
                //   ),
                // ),
                // SizedBox(
                //   width: 20,
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${model['title']}',
                          style: TextStyle(
                            color: index == 0 ? Colors.white : Colors.grey[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        '${model['date']}',
                        style: TextStyle(
                          color:
                              index == 0 ? Colors.grey[200] : Colors.grey[800],
                          //  fontWeight: FontWeight.bold
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.flag_circle_rounded,
                                color: index == 0
                                    ? Color(0XFFF37A7B)
                                    : Colors.grey[800],
                              ),
                            ),
                            Text('${model['priority']} Priority',
                                style: TextStyle(
                                  color: index == 0
                                      ? Colors.grey[200]
                                      : Colors.grey[800],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                Icons.alarm,
                                color: index == 0
                                    ? Colors.grey[200]
                                    : Colors.grey[800],
                              ),
                            ),
                            Text(
                              '${model['time']}',
                              style: TextStyle(
                                  color: index == 0
                                      ? Colors.grey[200]
                                      : Colors.grey[800],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // IconButton(
                //   onPressed: () {
                //     AppCubit.get(context).updateData(
                //       status: 'done',
                //       id: model['id'],
                //     );
                //   },
                //   icon: Icon(
                //     Icons.check_box,
                //     color: Colors.green,
                //   ),
                // ),
                IconButton(
                  onPressed: () {
                    if (AppCubit.get(context).currentIndex != 2) {
                      AppCubit.get(context).updateData(
                        status: 'archive',
                        id: model['id'],
                      );
                    } else {
                      AppCubit.get(context).updateData(
                        status: 'new',
                        id: model['id'],
                      );
                    }
                  },
                  icon: AppCubit.get(context).currentIndex != 2
                      ? Icon(Icons.archive_outlined)
                      : Icon(
                          Icons.unarchive_outlined,
                        ),
                ) //color: index == 0 ? Colors.white : Colors.grey[800]),
              ],
            ),
          ),
        ),
      ),
    );

Widget emptyTasksWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
