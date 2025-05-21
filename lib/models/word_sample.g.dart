// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_sample.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordSampleAdapter extends TypeAdapter<WordSample> {
  @override
  final int typeId = 2;

  @override
  WordSample read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordSample(
      id: fields[0] as int,
      wordId: fields[1] as int,
      sample: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordSample obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.wordId)
      ..writeByte(2)
      ..write(obj.sample);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
