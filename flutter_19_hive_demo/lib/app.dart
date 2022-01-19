import 'package:flutter/material.dart';
import 'package:flutter_19_hive_demo/todos/views/add_todo.dart';
import 'package:flutter_19_hive_demo/todos/views/home_todo.dart';
import 'package:flutter_19_hive_demo/todos/views/todo_detail.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Timer',
      routes: {
        AddTodoPage.routeName: (context) => const AddTodoPage(),
        TodoDetailPage.routeName: (context) => const TodoDetailPage(),
      },
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(109, 234, 255, 1),
        colorScheme: const ColorScheme.light(
          secondary: Color.fromRGBO(72, 74, 126, 1),
        ),
      ),
      home: const HomeTodoPage(),
    );
  }
}
