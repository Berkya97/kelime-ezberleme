// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnswerProgressAdapter extends TypeAdapter<AnswerProgress> {
  @override
  final int typeId = 1;

  @override
  AnswerProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnswerProgress(
      wordId: fields[0] as int,
      correctDates: (fields[1] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnswerProgress obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.wordId)
      ..writeByte(1)
      ..write(obj.correctDates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
