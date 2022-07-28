import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaty/screens/add_task_screen/add_task_screen.dart';
import 'package:taskaty/screens/schedule_screen/schedule_screen.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_cubit.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_states.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: BlocConsumer<TasksScreenCubit, TasksScreenStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = TasksScreenCubit.get(context);
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(),
                  ),
                ).then((value) {
                  cubit.getDataFromDB(cubit.db);
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ScheduleScreen();
                    }));
                  },
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
              title: const Text(
                'Taskaty',
                style: TextStyle(color: Colors.white),
              ),
              bottom: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Done",
                  ),
                  Tab(
                    text: "Not done",
                  ),
                  Tab(
                    text: "Favorites",
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TabBarView(
                children: [
                  ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              Color(int.parse(cubit.allTasks[index]['color'])),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Text(
                                cubit.allTasks[index]['title'],
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                              const Spacer(),
                              Checkbox(
                                  value: false,
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
                    itemCount: cubit.allTasks.length,
                  ),
                  const Center(
                    child: const Text("Completed tasks screen"),
                  ),
                  const Center(
                    child: Text("Un completed tasks"),
                  ),
                  const Center(
                    child: const Text("Favorite tasks"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
