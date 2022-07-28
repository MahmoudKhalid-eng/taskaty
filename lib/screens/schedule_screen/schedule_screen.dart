import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_cubit.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_states.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksScreenCubit,TasksScreenStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = TasksScreenCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Tasks Schedule',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DatePicker(
                  DateTime.now(),
                  initialSelectedDate: DateTime.now(),
                  selectionColor: const Color(0xFF25C06D),
                  selectedTextColor: Colors.white,
                  onDateChange: (date) {
                    cubit.getDate(date.toString());
                    print(date);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                          Color(int.parse(cubit.atDate[index]['color'])),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                cubit.atDate[index]['title'],
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                              const Spacer(),
                              Checkbox(
                                  value: true,
                                  onChanged: (value) {},
                                  checkColor: Color(0xFF25C06D),
                                  activeColor: Colors.white),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                    itemCount: cubit.atDate.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
