part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoLoadingDataState extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoLoadDataSuccessState extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoAddState extends TodoState {
  @override
  List<Object> get props => [];
}
