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
      create: (_) => TodoBloc(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Map<int, Widget> _children = {
    0: const Text('All'),
    1: const Text('Completed'),
    2: const Text('Incomplete'),
  };

  int _currentSelection = 0;

  final List<Widget> _listWidgets = const [
    AllTodosView(),
    CompletedTodosPage(),
    IncompleteTodosPage(),
  ];

  TodoType typeScreen = TodoType.all;

  final List<int> _disabledIndices = [];

  void _onSegmentChosen(int index) {
    switch (index) {
      case 0:
        typeScreen = TodoType.all;
        break;
      case 1:
        typeScreen = TodoType.completed;
        break;
      case 2:
        typeScreen = TodoType.incomplete;
        break;
      default:
        break;
    }
    setState(() {
      _currentSelection = index;
    });
  }

  void _gotoAddTodoPage() async {
    await Navigator.pushNamed(context, AddTodoPage.routeName);
    setState(() {
      context.read<TodoBloc>().add(TodoReloadDataEvent(typeScreen));
    });
  }

  Widget _materialSegmentedControl() {
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _materialSegmentedControl(),
              ],
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
    );
  }
}
