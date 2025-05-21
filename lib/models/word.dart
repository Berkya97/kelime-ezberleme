import 'package:hive/hive.dart';
part 'word.g.dart';

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String engWord;

  @HiveField(2)
  final String turWord;

  @HiveField(3)
  final String? exampleSentence;

  @HiveField(4)
  final String? imagePath;

  Word({
    required this.id,
    required this.engWord,
    required this.turWord,
    this.exampleSentence,
    this.imagePath,
  });
}
