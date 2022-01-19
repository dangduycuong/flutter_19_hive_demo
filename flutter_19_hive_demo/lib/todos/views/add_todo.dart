import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  static const routeName = 'AddTodoPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(),
      child: BlocConsumer<TodoBloc, TodoState>(
        builder: (context, state) {
          return const AddTodoView();
        },
        listener: (context, state) {
          if (state is TodoAddState) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class AddTodoView extends StatefulWidget {
  const AddTodoView({Key? key}) : super(key: key);

  @override
  _AddTodoViewState createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final TextEditingController _titleTodo = TextEditingController();
  final TextEditingController _descriptionTodo = TextEditingController();
  bool isCompleted = false;

  void _addTodo() {
    Todo newTodo = Todo(
      title: _titleTodo.text,
      description: _descriptionTodo.text,
      isCompleted: isCompleted,
    );
    context.read<TodoBloc>().add(TodoAddEvent(newTodo));
  }

  Widget _createElevatedButton(String title) {
    return Expanded(
      child: ElevatedButton(onPressed: () {
        if (title == 'Cancel') {
          Navigator.pop(context);
        } else {
          _addTodo();
        }
      }, child: Text(title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new todo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return TextFormField(
                      controller: _titleTodo,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'title of todo',
                      ),
                    );
                  }
                  if (index == 1) {
                    return TextFormField(
                      controller: _descriptionTodo,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'description', labelText: 'Description'),
                    );
                  }
                  return Row(
                    children: [
                      Checkbox(
                          value: isCompleted,
                          onChanged: (value) {
                            isCompleted = value!;
                            setState(() {});
                          }),
                      const Text('Completed'),
                    ],
                  );
                },
                itemCount: 3,
              ),
            ),
            Row(
              children: [
                _createElevatedButton('Cancel'),
                const SizedBox(
                  width: 8,
                ),
                _createElevatedButton('Save'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
