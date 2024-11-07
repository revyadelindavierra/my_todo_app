import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'todo_model.dart';

class InputTodoPage extends StatefulWidget {
  final Todo? todo;
  final int? index;

  InputTodoPage({this.todo, this.index});

  @override
  _InputTodoPageState createState() => _InputTodoPageState();
}

class _InputTodoPageState extends State<InputTodoPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'IMPORTANT';
  DateTime _dueDate = DateTime.now();
  String _status = 'Initial';

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _priority = widget.todo!.priority;
      _dueDate = widget.todo!.dueDate;
      _status = widget.todo!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButton<String>(
              value: _priority,
              onChanged: (newValue) => setState(() => _priority = newValue!),
              items: ['IMPORTANT', 'MEDIUM', 'LOW'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ListTile(
              title: Text("Due Date: ${_dueDate.toLocal()}".split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
            ),
            Row(
              children: [
                Text('Status: '),
                Expanded(
                  child: Row(
                    children: ['Initial', 'On Progress', 'Completed']
                        .map((status) => Expanded(
                              child: RadioListTile(
                                title: Text(status),
                                value: status,
                                groupValue: _status,
                                onChanged: (value) => setState(() => _status = value!),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                final newTodo = Todo()
                  ..title = _titleController.text
                  ..description = _descriptionController.text
                  ..priority = _priority
                  ..dueDate = _dueDate
                  ..status = _status;

                final box = Hive.box<Todo>('todos');
                if (widget.index == null) {
                  box.add(newTodo);
                } else {
                  box.putAt(widget.index!, newTodo);
                }

                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
