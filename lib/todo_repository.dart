import 'package:hive/hive.dart';
import 'todo_model.dart';

class TodoRepository {
  final Box<Todo> _todoBox = Hive.box<Todo>('todos');

  Future<void> addTodoItem(Todo todo) => _todoBox.add(todo);

  List<Todo> getTodos() => _todoBox.values.toList();

  Future<void> updateTodoItem(int index, Todo todo) => _todoBox.putAt(index, todo);

  Future<void> deleteTodoItem(int index) => _todoBox.deleteAt(index);
}
