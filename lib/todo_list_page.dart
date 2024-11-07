import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'input_todo_page.dart';
import 'todo_model.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final Box<Todo> todoBox = Hive.box<Todo>('todos');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todoBox.length,
      itemBuilder: (context, index) {
        final todo = todoBox.getAt(index) as Todo;
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title:
                Text(todo.title, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.description),
                Text('Priority: ${todo.priority}'),
                Text(
                    'Due Date: ${todo.dueDate.toLocal().toString().split(' ')[0]}'),
                Text('Status: ${todo.status}'),
                Text('Notes: ${todo.notes}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InputTodoPage(todo: todo, index: index),
                      ),
                    ).then((value) => setState(() {}));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Are you sure?'),
                          content:
                              Text('Do you really want to delete this item?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldDelete == true) {
                      todoBox.deleteAt(index);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
