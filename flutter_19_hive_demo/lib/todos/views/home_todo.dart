import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/bloc/todo_bloc.dart';
import 'package:flutter_19_hive_demo/todos/views/add_todo.dart';
import 'package:flutter_19_hive_demo/todos/views/all_todos.dart';
import 'package:flutter_19_hive_demo/todos/views/completed_todos.dart';
import 'package:flutter_19_hive_demo/todos/views/incomplete_todos.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class HomeTodoPage extends StatelessWidget {
  const HomeTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc()..add(TodoLoadDataEvent()),
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoadDataSuccessState) {
            return const HomeTodoView();
          }
          return Expanded(
            child: (Platform.isIOS)
                ? const Center(child: CupertinoActivityIndicator())
                : const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class HomeTodoView extends StatefulWidget {
  const HomeTodoView({Key? key}) : super(key: key);

  @override
  _HomeTodoViewState createState() => _HomeTodoViewState();
}

class _HomeTodoViewState extends State<HomeTodoView> {
  final List<Widget> _listWidgets = const [
    AllTodoPage(),
    CompletedTodosPage(),
    IncompleteTodosPage(),
  ];
  int _currentSelection = 0;

  void _gotoAddTodoPage() {
    Navigator.pushNamed(context, AddTodoPage.routeName);
  }

  void _onSegmentChosen(int index) {
    context.read<TodoBloc>().add(TodoReloadDataEvent());
  }

  Widget _buildMaterialSegmentedControl() {
    return Expanded(
      child: MaterialSegmentedControl(
        children: _children,
        selectionIndex: _currentSelection,
        borderColor: Colors.grey,
        selectedColor: Colors.redAccent,
        unselectedColor: Colors.white,
        borderRadius: 8.0,
        disabledChildren: _disabledIndices,
        onSegmentChosen: (i) {
          int index = i as int;

          _onSegmentChosen(index);
          setState(() {
            _currentSelection = i;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  _buildMaterialSegmentedControl(),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(child: _listWidgets[_currentSelection]),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _gotoAddTodoPage();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  final Map<int, Widget> _children = {
    0: const Text('All'),
    1: const Text('Completed'),
    2: const Text('Incomplete'),
  };

  // Holds all indices of children to be disabled.
  // Set this list either null or empty to have no children disabled.
  final List<int> _disabledIndices = [];
}
