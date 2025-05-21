import 'package:hive/hive.dart';

part 'word_sample.g.dart';

@HiveType(typeId: 2)
class WordSample {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int wordId;

  @HiveField(2)
  final String sample;

  WordSample({required this.id, required this.wordId, required this.sample});
}
