part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoLoadAllEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoAddEvent extends TodoEvent {
  final Todo todo;

  const TodoAddEvent(this.todo);

  @override
  List<Object?> get props => [todo];
}

class TodoDeleteEvent extends TodoEvent {
  final String id;

  final TodoType type;

  const TodoDeleteEvent(this.id, this.type);

  @override
  List<Object?> get props => [id];
}

class TodoReloadDataEvent extends TodoEvent {
  final TodoType type;
  const TodoReloadDataEvent(this.type);
  @override
  List<Object?> get props => [type];
}

class TodoLoadCompletedEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoLoadIncompleteEvent extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoViewDetailEvent extends TodoEvent {
  final int index;
  const TodoViewDetailEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class TodoModifyEvent extends TodoEvent {
  final Todo todo;
  const TodoModifyEvent(this.todo);
  @override
  List<Object?> get props => [todo];
}


