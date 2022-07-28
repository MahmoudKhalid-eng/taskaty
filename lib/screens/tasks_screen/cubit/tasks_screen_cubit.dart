import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskaty/screens/tasks_screen/cubit/tasks_screen_states.dart';

class TasksScreenCubit extends Cubit<TasksScreenStates> {
  TasksScreenCubit() : super(TasksScreenInitialState());

  static TasksScreenCubit get(context) => BlocProvider.of(context);
  Database? db;

  void createDB() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      database.execute(
          'CREATE TABLE myTasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,startTime TEXT,endTime TEXT,status TEXT, isFavorite TEXT, color TEXT)');
    }, onOpen: (db) {
      getDataFromDB(db);
    }).then((value) {
      db = value;
      emit(DataBaseCreateState());
    });
  }

  List<Map> allTasks = [];
  List<Map> doneTasks = [];
  List<Map> notDoneTasks = [];
  List<Map> favoriteTasks = [];
  List<Map> atDate = [];

  void getDataFromDB(db) {
    allTasks = [];
    doneTasks = [];
    notDoneTasks = [];
    favoriteTasks = [];
    emit(GetDataBaseLoadingState());
    db.rawQuery('SELECT * FROM myTasks').then((value) {
      value.forEach((element) {
        allTasks.add(element);
        if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          notDoneTasks.add(element);
        }
        if (element['isFavorite'] == 'Yes') {
          favoriteTasks.add(element);
        }
      });
      emit(GetDataBaseSuccessState());
    });
  }

  void insertDataBase({
    required title,
    required date,
    required startTime,
    required endTime,
    required color,
    required isFavorite,
  }) {
    emit(InsertDataBaseLoadingState());
    db!.transaction((txn) async {
      txn.rawInsert(
              'INSERT INTO myTasks (title,date,startTime,endTime,color,isFavorite,status) VALUES ("$title","$date","$startTime","$endTime","$color","$isFavorite","not done")')
          .then((value) {
        print(value.toString());
      });
    }).then((value) {
      emit(InsertDataBaseSuccessState());
    });
  }

  void updateDB({required String status, required int id}) {
    emit(UpdateDataBaseLoadingState());
    db!.rawUpdate(
        'UPDATE myTasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDB(db);
      emit(UpdateDataBaseSuccessState());
    });
  }

  void refresh(){
    emit(RefreshState());
  }

  void getDate(String date) {
    atDate = [];
    emit(GetDataBaseLoadingState());
    db!.rawQuery('SELECT * FROM myTasks').then((value) {
      value.forEach((element) {
        allTasks.add(element);
        if (element['date'] == date) {
          atDate.add(element);
        }
      });
      emit(GetDataBaseSuccessState());
    });
  }
}
