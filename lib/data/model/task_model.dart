import 'package:hive_flutter/hive_flutter.dart';
part  'task_model.g.dart';
@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  StatusTask status;

  @HiveField(3)
  int colorHex;

  TaskModel({
    required this.title,
    required this.description,
    required this.status,
    required this.colorHex,
  });
}

@HiveType(typeId: 2)
enum StatusTask {
  @HiveField(0)
  pending,
  
  @HiveField(1)
  done,
}