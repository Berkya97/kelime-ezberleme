import 'package:hive/hive.dart';
import '../models/word.dart';

class WordService {
  static Box<Word> get _box => Hive.box<Word>('words');

  /// Yeni bir kelime ekler. Hive kendi anahtarını (32-bit) atar.
  static Future<int> addWord(Word w) async {
    return await _box.add(w);
  }

  /// Tüm kelimeleri liste halinde döner.
  static List<Word> getAll() => _box.values.toList();

  /// Belirli bir id’ye sahip kelimeyi getirir.
  static Word? getById(int id) {
    try {
      return _box.values.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Bir kelimeyi Hive içinden siler (box key’iyle).
  static Future<void> deleteById(int id) async {
    final key = _box.keys.firstWhere(
          (k) => (_box.get(k) as Word).id == id,
      orElse: () => null,
    );
    if (key != null) await _box.delete(key);
  }
}
