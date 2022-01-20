import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_19_hive_demo/todos/views/todo_detail.dart';
import 'package:flutter_19_hive_demo/widgets/loading_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTodosView extends StatefulWidget {
  const AllTodosView({Key? key}) : super(key: key);
  @override
  _AllTodosViewState createState() => _AllTodosViewState();
}

class _AllTodosViewState extends State<AllTodosView> {
  late TodoBloc bloc;

  @override
  void initState() {
    bloc = context.read();
    bloc.add(TodoLoadAllEvent());
    super.initState();
  }
  void _gotoTodoDetail(int index) async {
    await Navigator.pushNamed(context, TodoDetailPage.routeName,
        arguments: index);
    setState(() {});
  }

  void _modifyTodo(int index, Todo todo) {
    Todo newTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
    );
    context.read<TodoBloc>().add(TodoModifyEvent(newTodo));
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          Todo todo = context.read<TodoBloc>().todos[index];
          return InkWell(
            onTap: () {
              _gotoTodoDetail(index);
            },
            child: Row(
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    _modifyTodo(index, todo);
                    setState(() {});
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(todo.title),
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
                    context
                        .read<TodoBloc>()
                        .add(TodoDeleteEvent(todo.id, TodoType.all));
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        },
        itemCount: bloc.todos.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: [
            _buildListView(),
            Text('${bloc.todos.length}'),
          ],
        );
      },
    );
  }
}
