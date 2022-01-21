import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_19_hive_demo/todos/views/todo_detail.dart';
import 'package:flutter_19_hive_demo/widgets/loading_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompletedTodosView extends StatefulWidget {
  const CompletedTodosView({Key? key}) : super(key: key);

  @override
  _CompletedTodosViewState createState() => _CompletedTodosViewState();
}

class _CompletedTodosViewState extends State<CompletedTodosView> {
  late TodoBloc bloc;
  TodoType todoType = TodoType.completed;

  @override
  void initState() {
    bloc = context.read();
    bloc.add(TodoLoadDataEvent(todoType));
    super.initState();
  }

  void _gotoTodoDetail(BuildContext context, String id) async {
    await Navigator.pushNamed(context, TodoDetailPage.routeName, arguments: id);
    bloc.add(TodoLoadDataEvent(todoType));
    setState(() {});
  }

  void _modifyTodo(bool isCompleted, Todo todo) {
    Todo newTodo = Todo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: isCompleted,
    );
    bloc.add(TodoModifyEvent(newTodo));
  }

  Color _colorTitle(bool isCompleted) {
    return isCompleted ? Colors.green : Colors.red;
  }

  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          Todo todo = bloc.todos[index];
          return InkWell(
            onTap: () {
              _gotoTodoDetail(context, todo.id);
            },
            child: Row(
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    _modifyTodo(value!, todo);
                    setState(() {});
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        maxLines: 1,
                        style: TextStyle(
                          color: _colorTitle(todo.isCompleted),
                          fontWeight: FontWeight.bold,
                        ),
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
                    bloc.add(TodoDeleteEvent(todo.id, todoType));
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
      listener: (context, state) {
        if (state is TodoModifyState) {
          bloc.add(TodoLoadDataEvent(todoType));
        }
      },
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
