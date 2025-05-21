import 'package:flutter/material.dart';
import 'package:kelim_ezberleme/services/word_service.dart';
import 'package:kelim_ezberleme/services/word_sample_service.dart';
import 'package:kelim_ezberleme/services/progress_service.dart';
import 'package:kelim_ezberleme/services/settings_service.dart';
import '../models/word.dart';

class TestScreen extends StatefulWidget {
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestionIndex = 0;
  late List<Word> _allWords;
  List<Word> _questions = [];
  late List<String> _options;
  String? _currentSample;
  String? _currentImage;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    // Tüm kelimeleri al
    _allWords = WordService.getAll();
    // Sınav sorularını oluştur
    _generateTestQuestions();
    // İlk soruyu hazırla
    _prepareCurrentQuestion();
  }

  void _generateTestQuestions() {
    final List<Word> timeToAsk = [];
    // Vadesi gelen ve henüz 6 defa geçerli bilinememiş kelimeler
    for (final word in _allWords) {
      final progress = ProgressService.getProgress(word.id);
      if (progress.correctDates.isEmpty) continue;
      if (!ProgressService.shouldAskToday(progress)) continue;
      if (progress.correctDates.length >= 6) continue;
      timeToAsk.add(word);
    }
    // Hiç doğru işaretlenmemiş yeni kelimeler
    final newWords = _allWords.where((w) {
      final prog = ProgressService.getProgress(w.id);
      return prog.correctDates.isEmpty;
    }).toList()..shuffle();
    final extraNew = newWords.take(newWordsCount).toList();

    _questions = [...timeToAsk, ...extraNew]..shuffle();
    if (_questions.isEmpty) {
      _questions = newWords.take(newWordsCount).toList();
    }
  }

  void _prepareCurrentQuestion() {
    if (_questions.isEmpty) return;
    final w = _questions[_currentQuestionIndex];
    // Şık seçenekler: 1 doğru + 3 yanlış
    final wrong = _allWords.where((x) => x.id != w.id).toList()..shuffle();
    _options = [w.turWord, ...wrong.take(3).map((x) => x.turWord)].toList()..shuffle();
    // Örnek cümle
    final samples = WordSampleService.getSamples(w.id);
    _currentSample = samples.isNotEmpty ? (samples..shuffle()).first.sample : null;
    // Resim asset
    _currentImage = w.imagePath;
  }

  Future<void> _answerQuestion(bool isCorrect) async {
    final w = _questions[_currentQuestionIndex];
    // Kaydet
    await ProgressService.updateProgress(w.id, isCorrect);
    if (isCorrect) _score++;
    // Geri bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Doğru!' : 'Yanlış!'),
        backgroundColor: isCorrect ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 700),
      ),
    );
    // Sonraki soru veya sonuç
    await Future.delayed(const Duration(milliseconds: 700));
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _prepareCurrentQuestion();
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Test Bitti'),
        content: Text('Doğru Sayısı: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sınav')),
        body: const Center(child: Text('Sınav için yeterli kelime yok.')),
      );
    }
    final currentWord = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Sınav')),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 6,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Soru ${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (_currentImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        _currentImage!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (_currentImage != null) const SizedBox(height: 12),
                  if (_currentSample != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _currentSample!,
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  Text(
                    '"${currentWord.engWord}" kelimesinin Türkçesi nedir?',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  for (final opt in _options)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => _answerQuestion(opt == currentWord.turWord),
                          child: Text(opt, style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
