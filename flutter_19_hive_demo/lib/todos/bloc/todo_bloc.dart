import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:hive/hive.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late final Box box;

  TodoBloc() : super(TodoInitial()) {
    on<TodoLoadDataEvent>(_loadTodos);
    on<TodoAddEvent>(_addTodo);
    on<TodoAddEvent>(_addTodo);
  }

  void _loadTodos(TodoLoadDataEvent event, Emitter<TodoState> emit) {
    print('cdd calling');
    emit(TodoLoadingDataState());
    box = Hive.box('todosBox');
    emit(TodoLoadDataSuccessState());
  }

  void _addTodo(TodoAddEvent event, Emitter<TodoState> emit) async {
    Todo todo = event.todo;
    try {
      box = Hive.box('todosBox');
      await box.add(todo);
    } catch (_) {}

    emit(TodoAddState());
  }

  void _reloadData(TodoReloadDataEvent event, Emitter<TodoState> emit) {
    emit(TodoLoadDataSuccessState());
  }
}
