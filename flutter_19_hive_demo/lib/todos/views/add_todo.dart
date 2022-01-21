import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/models/todo_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  static const routeName = 'AddTodoPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(),
      child: const AddTodoView(),
    );
  }
}

class AddTodoView extends StatefulWidget {
  const AddTodoView({Key? key}) : super(key: key);

  @override
  _AddTodoViewState createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTodo = TextEditingController();
  final TextEditingController _descriptionTodo = TextEditingController();
  bool isCompleted = false;
  bool idValidTitle = true;

  String _generateID() {
    var uuid = const Uuid();

    // Generate a v1 (time-based) id
    String v1 = uuid.v1();
    return v1;
  }

  void _addTodo() {
    Todo newTodo = Todo(
      id: _generateID(),
      title: _titleTodo.text,
      description: _descriptionTodo.text,
      isCompleted: isCompleted,
    );
    context.read<TodoBloc>().add(TodoAddEvent(newTodo));
  }

  Widget _createElevatedButton(String title) {
    return Expanded(
      child: ElevatedButton(
          onPressed: () {
            if (title == 'Cancel') {
              Navigator.pop(context);
            } else {
              if (_formKey.currentState!.validate()) {
                _addTodo();
              }
            }
          },
          child: Text(title)),
    );
  }

  Widget _titleTodoTextFormField() {
    return TextFormField(
      controller: _titleTodo,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter title',
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'todo title cannot empty';
        }
        return null;
      },
    );
  }

  Widget _descriptionTodoTextFormField() {
    return TextFormField(
      controller: _descriptionTodo,
      maxLines: 5,
      autocorrect: true,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Enter description',
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'todo description cannot empty';
        }
        return null;
      },
    );
  }

  Widget _isCompletedCheckboxItem() {
    return InkWell(
      onTap: () {
        isCompleted = !isCompleted;
        setState(() {});
      },
      child: Row(
        children: [
          Checkbox(
              value: isCompleted,
              onChanged: (value) {
                isCompleted = value!;
                setState(() {});
              }),
          const Text('Completed'),
        ],
      ),
    );
  }

  Widget _formTodo() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return _titleTodoTextFormField();
            case 1:
              return _descriptionTodoTextFormField();
            default:
              return _isCompletedCheckboxItem();
          }
        },
        itemCount: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add New Todo'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _formTodo(),
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
        if (state is TodoAddState) {
          Navigator.pop(context);
        }
      },
    );
  }
}
