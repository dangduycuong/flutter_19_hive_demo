import 'package:flutter/material.dart';

class CompletedTodosPage extends StatefulWidget {
  const CompletedTodosPage({Key? key}) : super(key: key);

  @override
  _CompletedTodosPageState createState() => _CompletedTodosPageState();
}

class _CompletedTodosPageState extends State<CompletedTodosPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return const Text('Completed');
              },
              itemCount: 120,
            ),
          ),
          Text('123'),
        ],
      ),
    );
  }
}
