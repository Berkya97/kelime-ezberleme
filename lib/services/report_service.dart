import '../models/word.dart';
import '../services/word_service.dart';
import '../services/progress_service.dart';

/// Bir kelimenin öğrenme oranını (0–100) hesaplar.
double wordProgressPercent(Word w) {
  final prog = ProgressService.getProgress(w.id);
  final taken = prog.correctDates.length.clamp(0, 6);
  return taken / 6 * 100;
}

/// Tüm kelimeler üzerinden ortalama başarı yüzdesi.
double overallProgressPercent() {
  final allWords = WordService.getAll();
  if (allWords.isEmpty) return 0.0;
  final sum = allWords.fold<double>(
    0,
        (acc, w) => acc + wordProgressPercent(w),
  );
  return sum / allWords.length;
}

/// Her kelimeyi ve öğrenme yüzdesini ikililer halinde döner.
List<MapEntry<Word, double>> detailedProgress() {
  final allWords = WordService.getAll();
  final entries = allWords
      .map((w) => MapEntry<Word, double>(w, wordProgressPercent(w)))
      .toList();
  entries.sort((a, b) => b.value.compareTo(a.value)); // en yüksekten
  return entries;
}
