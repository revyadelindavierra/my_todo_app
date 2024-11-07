import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String priority;

  @HiveField(3)
  late DateTime dueDate;

  @HiveField(4)
  late String status;
}
