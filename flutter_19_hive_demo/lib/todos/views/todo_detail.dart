import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({Key? key}) : super(key: key);

  static const routeName = 'TodoDetailPage';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    return BlocProvider(
      create: (_) => TodoBloc()..add(TodoViewDetailEvent(id)),
      child: const TodoDetailView(),
    );
  }
}

class TodoDetailView extends StatefulWidget {
  const TodoDetailView({Key? key}) : super(key: key);

  @override
  _TodoDetailViewState createState() => _TodoDetailViewState();
}

class _TodoDetailViewState extends State<TodoDetailView> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  TextEditingController _titleTodo = TextEditingController();
  TextEditingController _descriptionTodo = TextEditingController();
  bool isCompleted = false;

  void _modifyTodo() {
    Todo newTodo = Todo(
      id: id,
      title: _titleTodo.text,
      description: _descriptionTodo.text,
      isCompleted: isCompleted,
    );
    context.read<TodoBloc>().add(TodoModifyEvent(newTodo));
  }

  Widget _createElevatedButton(String title) {
    return Expanded(
      child: ElevatedButton(
          onPressed: () {
            if (title == 'Cancel') {
              Navigator.pop(context);
            } else {
              if (_formKey.currentState!.validate()) {
                _modifyTodo();
              }
            }
          },
          child: Text(title)),
    );
  }

  Widget _titleTodoTextFormField() {
    return TextFormField(
      controller: _titleTodo,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Todo title cannot empty';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter title',
      ),
    );
  }

  Widget _descriptionTodoTextFormField() {
    return TextFormField(
      controller: _descriptionTodo,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Todo description cannot empty';
        }
        return null;
      },
      maxLines: 5,
      autocorrect: true,
      decoration: const InputDecoration(
          hintText: 'Enter description', labelText: 'Todo description'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo Detail'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _titleTodoTextFormField();
                        }
                        if (index == 1) {
                          return _descriptionTodoTextFormField();
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
          ),
        );
      },
      listener: (context, state) {
        if (state is TodoDetailState) {
          id = state.todo.id;
          _titleTodo = TextEditingController(text: state.todo.title);
          _descriptionTodo =
              TextEditingController(text: state.todo.description);
          isCompleted = state.todo.isCompleted;
        }
        if (state is TodoModifyState) {
          Navigator.pop(context);
        }
      },
    );
  }
}
