import 'package:hive/hive.dart';
import '../models/answer_progress.dart';

/// Hive tabanlı kalıcı ilerleme servisi
class ProgressService {
  static Box<AnswerProgress> get _box => Hive.box<AnswerProgress>('progress');

  /// Kelimeye ait ilerleme kaydını getirir veya yenisini oluşturur.
  static AnswerProgress getProgress(int wordId) {
    final p = _box.get(wordId);
    if (p != null) return p;
    final fresh = AnswerProgress(wordId: wordId, correctDates: []);
    _box.put(wordId, fresh);
    return fresh;
  }

  /// Doğru/yanlış cevabı kaydeder ve Hive'a yazar.
  static Future<void> updateProgress(int wordId, bool isCorrect) async {
    final p = getProgress(wordId);
    if (isCorrect) {
      if (p.correctDates.length < 6) {
        p.correctDates.add(DateTime.now());
      }
    } else {
      p.correctDates.clear();
    }
    await _box.put(wordId, p);
  }

  /// Bu kelimeyi bugün sormalı mı? 1g,7g,30g,… aralıklarını kontrol eder.
  static bool shouldAskToday(AnswerProgress progress) {
    if (progress.correctDates.isEmpty) return true;
    final now = DateTime.now();
    const intervals = [
      Duration(days: 1),
      Duration(days: 7),
      Duration(days: 30),
      Duration(days: 90),
      Duration(days: 180),
      Duration(days: 365),
    ];
    final idx = (progress.correctDates.length - 1).clamp(0, intervals.length - 1);
    final due = progress.correctDates.last.add(intervals[idx]);
    return now.year > due.year ||
           (now.year == due.year && now.month > due.month) ||
           (now.year == due.year && now.month == due.month && now.day >= due.day);
  }
}
