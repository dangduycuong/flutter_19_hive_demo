import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_19_hive_demo/todos/views/todo_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class IncompleteTodosPage extends StatelessWidget {
  const IncompleteTodosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TodoBloc(),
    child: const IncompleteTodosView(),);
  }
}


class IncompleteTodosView extends StatefulWidget {
  const IncompleteTodosView({Key? key}) : super(key: key);

  @override
  _IncompleteTodosViewState createState() => _IncompleteTodosViewState();
}

class _IncompleteTodosViewState extends State<IncompleteTodosView> {
  _deleteInfo(int index) {
    context.read<TodoBloc>().add(TodoDeleteEvent(index));
  }

  Widget _buildListView(Box box) {
    return ListView.builder(
      itemCount: box.length,
      itemBuilder: (context, index) {
        Todo todo = box.getAt(index);

        return InkWell(
          onTap: () => _navigateAndDisplayReloadUpdate(context, index),
          child: _buildCellForRow(todo, index),
        );
      },
    );
  }

  void _navigateAndDisplayReloadUpdate(BuildContext context, int index) async {
    await Navigator.pushNamed(context, TodoDetailPage.routeName,
        arguments: index);
    // context.read<TodoBloc>().add(TodoReloadDataEvent());
    setState(() {

    });

    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(const SnackBar(content: Text('Update todo success')));
  }

  Widget _buildCellForRow(Todo todo, int index) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (value) {
          Todo newTodo = Todo(
            title: todo.title,
            description: todo.description,
            isCompleted: value!,
          );
          setState(() {

          });
          // context.read<TodosBloc>().add(TodosModifyEvent(index, newTodo));
        },
      ),
      title: Text(
        todo.title,
      ),
      subtitle: Text(
        todo.description,
        maxLines: 1,
      ),
      trailing: IconButton(
        onPressed: () {
          _deleteInfo(index);
          setState(() {

          });
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildListView(context.read<TodoBloc>().box);
  }
}
