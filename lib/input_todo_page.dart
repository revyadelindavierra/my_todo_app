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
  final _dueDateController = TextEditingController();
  final _notesController = TextEditingController(); 
  String _priority = 'IMPORTANT';
  DateTime _dueDate = DateTime.now();
  String _status = 'On Progress';

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _priority = widget.todo!.priority;
      _dueDate = widget.todo!.dueDate;
      _status = widget.todo!.status;
      _dueDateController.text = _formatDate(_dueDate);
      _notesController.text = widget.todo!.notes; 
    } else {
      _dueDateController.text = _formatDate(_dueDate);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _pickDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = _formatDate(_dueDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(labelText: 'Priority'),
              onChanged: (newValue) => setState(() => _priority = newValue!),
              items: ['IMPORTANT', 'MEDIUM', 'LOW'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dueDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Due Date',
                border: UnderlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pickDueDate,
            ),
            SizedBox(height: 16),
            Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: ['Initial', 'On Progress', 'Completed'].map((status) {
                return Expanded(
                  child: RadioListTile<String>(
                    title: Text(status),
                    value: status,
                    groupValue: _status,
                    onChanged: (value) => setState(() => _status = value!),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Notes',
                border: UnderlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final newTodo = Todo()
                    ..title = _titleController.text
                    ..description = _descriptionController.text
                    ..priority = _priority
                    ..dueDate = _dueDate
                    ..status = _status
                    ..notes = _notesController.text; 
                  

                  final box = Hive.box<Todo>('todos');
                  if (widget.index == null) {
                    box.add(newTodo);
                  } else {
                    box.putAt(widget.index!, newTodo);
                  }

                  Navigator.pop(context);
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
