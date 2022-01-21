import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:hive/hive.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  late final Box box;

  List<Todo> todos = [];

  TodoBloc() : super(TodoInitial()) {
    on<TodoInitBoxEvent>(_initBox);
    on<TodoLoadDataEvent>(_loadTodosData);
    on<TodoAddEvent>(_addTodo);
    on<TodoReloadDataEvent>(_reloadData);
    on<TodoLoadCompletedEvent>(_loadTodoCompleted);
    on<TodoLoadIncompleteEvent>(_loadTodoIncomplete);
    on<TodoViewDetailEvent>(_getTodoDetail);
    on<TodoModifyEvent>(_modifyTodo);
    on<TodoDeleteEvent>(_deleteTodo);
  }

  void _initBox(TodoInitBoxEvent event, Emitter<TodoState> emit) {
    box = Hive.box('todosBox');
  }

  void _loadTodosData(TodoLoadDataEvent event, Emitter<TodoState> emit) {
    emit(TodoLoadingDataState());


    int count = getCount(event.type);
    emit(TodoLoadDataSuccessState(count));
  }

  void _reloadData(TodoReloadDataEvent event, Emitter<TodoState> emit) {

    int count = getCount(event.type);
    emit(TodoLoadDataSuccessState(count));
  }

  void _loadTodoCompleted(
      TodoLoadCompletedEvent event, Emitter<TodoState> emit) {
    emit(TodoLoadingDataState());
    box = Hive.box('todosBox');

    int count = getCount(TodoType.completed);
    emit(TodoLoadDataSuccessState(count));
  }

  int getCount(TodoType type) {
    todos = [];
    for (int index = 0; index < box.length; index++) {
      final Todo todo = box.getAt(index) as Todo;
      switch (type) {
        case (TodoType.all):
          todos.add(todo);
          break;
        case TodoType.completed:
          if (todo.isCompleted) {
            todos.add(todo);
          }
          break;
        case TodoType.incomplete:
          if (todo.isCompleted == false) {
            todos.add(todo);
          }
          break;
      }
    }
    return todos.length;
  }

  void _loadTodoIncomplete(
      TodoLoadIncompleteEvent event, Emitter<TodoState> emit) {
    emit(TodoLoadingDataState());
    box = Hive.box('todosBox');

    int count = getCount(TodoType.incomplete);

    emit(TodoLoadDataSuccessState(count));
  }

  void _addTodo(TodoAddEvent event, Emitter<TodoState> emit) async {
    Todo todo = event.todo;
    try {
      box = Hive.box('todosBox');
      await box.add(todo);
    } catch (_) {}

    emit(TodoAddState());
  }

  void _modifyTodo(TodoModifyEvent event, Emitter<TodoState> emit) {
    Todo newTodo = event.todo;
    int index = _getIndexOfItem(event.todo.id);

    box.putAt(index, newTodo);

    emit(TodoModifyState());
  }

  void _deleteTodo(TodoDeleteEvent event, Emitter<TodoState> emit) {
    box.deleteAt(_getIndexOfItem(event.id));
    int count = getCount(event.type);
    emit(TodoLoadDataSuccessState(count));
  }

  void _getTodoDetail(
      TodoViewDetailEvent event, Emitter<TodoState> emit) async {
    box = Hive.box('todosBox');
    int index = _getIndexOfItem(event.id);
    Todo todo = box.getAt(index) as Todo;

    emit(TodoDetailState(index, todo));
  }

  int _getIndexOfItem(String id) {
    int index = 0;
    for (int i = 0; i < box.length; i++) {
      final Todo todo = box.getAt(i) as Todo;
      if (todo.id == id) {
        index = i;
        break;
      }
    }
    return index;
  }
}

enum TodoType { all, completed, incomplete }
