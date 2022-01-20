import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_19_hive_demo/todos/views/todo_detail.dart';
import 'package:flutter_19_hive_demo/widgets/loading_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncompleteTodosPage extends StatelessWidget {
  const IncompleteTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc()..add(TodoLoadIncompleteEvent()),
      child: BlocConsumer<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoadDataSuccessState) {
              return const IncompleteTodosView();
            }
            return const LoadingView();
          },
          listener: (context, state) {}),
    );
  }
}

class IncompleteTodosView extends StatefulWidget {
  const IncompleteTodosView({Key? key}) : super(key: key);

  @override
  _IncompleteTodosViewState createState() => _IncompleteTodosViewState();
}

class _IncompleteTodosViewState extends State<IncompleteTodosView> {
  Widget _buildListView() {
    return ListView.builder(
      itemCount: context.read<TodoBloc>().todos.length,
      itemBuilder: (context, index) {
        Todo todo = context.read<TodoBloc>().todos[index];

        return InkWell(
          onTap: () => _gotoTodoDetail(context, index),
          child: _buildCellForRow(todo, index),
        );
      },
    );
  }

  void _gotoTodoDetail(BuildContext context, int index) async {
    await Navigator.pushNamed(context, TodoDetailPage.routeName,
        arguments: index);
    context.read<TodoBloc>().add(TodoLoadIncompleteEvent());
  }

  Widget _buildCellForRow(Todo todo, int index) {
    return Row(
      children: [
        Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {},
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                todo.title,
              ),
              Text(
                todo.description,
                maxLines: 1,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            context.read<TodoBloc>().add(TodoDeleteEvent(todo.id, TodoType.incomplete));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      return Column(
        children: [
          Expanded(
            child: _buildListView(),
          ),
          Text('${context.read<TodoBloc>().todos.length}'),
        ],
      );
    });
  }
}
