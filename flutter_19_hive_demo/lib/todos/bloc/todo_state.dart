part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoLoadingDataState extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoadDataSuccessState extends TodoState {
  final int count;

  const TodoLoadDataSuccessState(this.count);

  @override
  List<Object> get props => [count];
}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoAddState extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoDetailState extends TodoState {
  final int index;
  final Todo todo;

  const TodoDetailState(this.index, this.todo);

  @override
  List<Object> get props => [index, todo];
}

class TodoModifyState extends TodoState {

  @override
  List<Object> get props => [];
}
