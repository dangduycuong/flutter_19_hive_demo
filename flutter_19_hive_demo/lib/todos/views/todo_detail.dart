import 'package:flutter/material.dart';

class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({Key? key}) : super(key: key);

  static const routeName = 'TodoDetailPage';

  @override
  Widget build(BuildContext context) {
    final int index = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail of $index'),
      ),
    );
  }
}
