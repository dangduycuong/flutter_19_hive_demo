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
              _addTodo();
            }
          },
          child: Text(title)),
    );
  }

  void _updateTodoStatus(bool currentStatus) {
    isCompleted = !currentStatus;
    setState(() {});
  }

  Widget _titleTodoTextFormField() {
    return TextFormField(
      controller: _titleTodo,
      onChanged: (value){
        idValidTitle = value.isNotEmpty;
        setState(() {

        });
      },
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'title of todo',
        errorText: idValidTitle ? null: 'nhap di' ,
      ),
    );
  }

  Widget _descriptionTodoTextFormField() {
    return TextFormField(
      controller: _descriptionTodo,
      maxLines: null,
      decoration: const InputDecoration(
          hintText: 'description', labelText: 'Description'),
    );
  }

  Widget _isCompletedTodo() {
    return InkWell(
      onTap: () {
        _updateTodoStatus(isCompleted);
      },
      child: Row(
        children: [
          Checkbox(
              value: isCompleted,
              onChanged: (value) {
                _updateTodoStatus(!value!);
              }),
          const Text('Completed'),
        ],
      ),
    );
  }

  Widget _confirmFormBottomButton() {
    return Row(
      children: [
        _createElevatedButton('Cancel'),
        const SizedBox(
          width: 8,
        ),
        _createElevatedButton('Save'),
      ],
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
                    return _titleTodoTextFormField();
                  }
                  if (index == 1) {
                    return _descriptionTodoTextFormField();
                  }
                  return _isCompletedTodo();
                },
                itemCount: 3,
              ),
            ),
            _confirmFormBottomButton(),
          ],
        ),
      ),
    );
  }
}
