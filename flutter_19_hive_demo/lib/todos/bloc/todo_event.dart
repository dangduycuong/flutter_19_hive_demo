part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoLoadDataEvent extends TodoEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class TodoAddEvent extends TodoEvent {
  final Todo todo;

  const TodoAddEvent(this.todo);

  @override
  // TODO: implement props
  List<Object?> get props => [todo];
}

class TodoDeleteEvent extends TodoEvent {
  final int index;

  const TodoDeleteEvent(this.index);

  @override
// TODO: implement props
  List<Object?> get props => [index];
}

class TodoReloadDataEvent extends TodoEvent {
  @override
// TODO: implement props
  List<Object?> get props => [];
}
