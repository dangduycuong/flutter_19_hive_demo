import 'package:flutter/material.dart';

class AllTodoPage extends StatefulWidget {
  const AllTodoPage({Key? key}) : super(key: key);

  @override
  _AllTodoPageState createState() => _AllTodoPageState();
}

class _AllTodoPageState extends State<AllTodoPage> {
  Widget _buildListView() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: ListTile(
              leading: Checkbox(
                value: (index % 2) == 0,
                onChanged: (value) {},
              ),
            ),
          );
        },
        itemCount: 120,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildListView(),
          Text('123'),
        ],
      ),
    );
  }
}
