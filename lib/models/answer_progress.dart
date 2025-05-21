import 'package:hive/hive.dart';
part 'answer_progress.g.dart';

@HiveType(typeId: 1)
class AnswerProgress {
  @HiveField(0)
  final int wordId;

  @HiveField(1)
  final List<DateTime> correctDates;

  AnswerProgress({required this.wordId, required this.correctDates});

  bool isFullyLearned() => correctDates.length >= 6;
}