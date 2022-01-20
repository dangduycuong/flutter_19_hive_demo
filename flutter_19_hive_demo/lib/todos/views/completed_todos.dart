import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_19_hive_demo/todos/views/todo_detail.dart';
import 'package:flutter_19_hive_demo/widgets/loading_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedTodosPage extends StatelessWidget {
  const CompletedTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc()..add(TodoLoadCompletedEvent()),
      child: BlocConsumer<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoadDataSuccessState) {
            return const CompletedTodosView();
          }
          return const LoadingView();
        },
        listener: (context, state) {},
      ),
    );
  }
}

class CompletedTodosView extends StatefulWidget {
  const CompletedTodosView({Key? key}) : super(key: key);

  @override
  _CompletedTodosViewState createState() => _CompletedTodosViewState();
}

class _CompletedTodosViewState extends State<CompletedTodosView> {
  void _gotoTodoDetail(int index) {
    Navigator.pushNamed(context, TodoDetailPage.routeName, arguments: index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              Todo todo = context.read<TodoBloc>().todos[index];
              return InkWell(
                onTap: () {
                  _gotoTodoDetail(index);
                },
                child: Row(
                  children: [
                    Checkbox(value: todo.isCompleted, onChanged: (value) {}),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            todo.title,
                            style: const TextStyle(fontFamily: 'RobotoMono'),
                          ),
                          Text(
                            todo.description,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          context
                              .read<TodoBloc>()
                              .add(TodoDeleteEvent(todo.id, TodoType.completed));
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove)),
                  ],
                ),
              );
            },
            itemCount: context.read<TodoBloc>().todos.length,
          ),
        ),
        Text('${context.read<TodoBloc>().todos.length}'),
      ],
    );
  }
}
