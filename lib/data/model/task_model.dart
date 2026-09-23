// ignore_for_file: public_member_api_docs
class TaskModel {
  String title;
  String description;
  StatusTask status;
  int colorHex;
  
  TaskModel({
    required this.title,
    required this.description,
    required this.status,
    required this.colorHex,
  });
}

enum StatusTask { pending, done }