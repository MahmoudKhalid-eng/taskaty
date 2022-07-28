import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_cubit.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_states.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  String date =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  String startTime = TimeOfDay.now().toString();
  String endTime = TimeOfDay.now().toString();
  int color = 0;

  List<int> colors = [
    0XFF246EE9,
    0XFFFF2400,
    0XFF3EB489,
    0XFFec407a,
    0XFFab47bc,
    0XFF66bb6a,
    0XFFffee58,
    0XFF8d6e63,
    0XFFbdbdbd,
    0XFF26c6da,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksScreenCubit, TasksScreenStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = TasksScreenCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add Task',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task title',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      suffixIcon: Icon(
                        Icons.title_outlined,
                        color: Color(0xFF25C06D),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Title Can\t be null';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(2030),
                      ).then((value) {
                        date = '${value!.year}-${value.month}-${value.day}';
                        dateController.text = date;
                      });
                    },
                    child: TextFormField(
                      controller: dateController,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(),
                        suffixIcon: Icon(
                          Icons.date_range_sharp,
                          color: Color(0xFF25C06D),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            ).then((value) {
                              startTimeController.text = startTime;
                              startTime = value.toString();
                            });
                          },
                          child: TextFormField(
                            controller: startTimeController,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'Start time',
                              border: OutlineInputBorder(),
                              disabledBorder: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.watch_later_outlined,
                                color: Color(0xFF25C06D),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            ).then((value) {
                              endTimeController.text = endTime;
                              endTime = value.toString();
                            });
                          },
                          child: TextFormField(
                            controller: endTimeController,
                            enabled: false,
                            decoration: const InputDecoration(
                              labelText: 'End time',
                              border: OutlineInputBorder(),
                              disabledBorder: OutlineInputBorder(),
                              suffixIcon: Icon(
                                Icons.lock_clock,
                                color: Color(0xFF25C06D),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            color = index;
                            cubit.refresh();
                          },
                          child: CircleAvatar(
                            backgroundColor: Color(colors[index]),
                            child: index == color
                                ? const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 5,
                                  )
                                : Container(),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 8,
                        );
                      },
                      itemCount: colors.length,
                    ),
                  ),
                  const Spacer(),
                  MaterialButton(
                    color: const Color(0xFF25C06D),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.insertDataBase(
                          title: titleController.text,
                          date: date,
                          startTime: startTime,
                          endTime: endTime,
                          color: colors[color],
                          isFavorite: false,
                        );
                        Navigator.pop(context);
                      }
                    },
                    minWidth: double.infinity,
                    height: 55,
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
