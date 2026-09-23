// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      title: fields[0] as String,
      description: fields[1] as String,
      status: fields[2] as StatusTask,
      colorHex: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.colorHex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusTaskAdapter extends TypeAdapter<StatusTask> {
  @override
  final int typeId = 2;

  @override
  StatusTask read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StatusTask.pending;
      case 1:
        return StatusTask.done;
      default:
        return StatusTask.pending;
    }
  }

  @override
  void write(BinaryWriter writer, StatusTask obj) {
    switch (obj) {
      case StatusTask.pending:
        writer.writeByte(0);
        break;
      case StatusTask.done:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
