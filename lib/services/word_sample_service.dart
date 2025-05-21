import 'package:hive/hive.dart';
import '../models/word_sample.dart';

class WordSampleService {
  static Box<WordSample> get _box => Hive.box<WordSample>('samples');

  /// Yeni örnek cümle ekler. Hive kendi anahtarını atar.
  static Future<int> addSample(WordSample s) async {
    return await _box.add(s);
  }

  /// Belirli bir kelimeye ait örnek cümleleri döner.
  static List<WordSample> getSamples(int wordId) {
    return _box.values.where((s) => s.wordId == wordId).toList();
  }

  /// Tüm örnek cümleleri temizler.
  static Future<void> clear() async {
    await _box.clear();
  }
}
