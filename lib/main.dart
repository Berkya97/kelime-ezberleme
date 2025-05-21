import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'models/user.dart';
import 'models/word.dart';
import 'models/answer_progress.dart';
import 'models/word_sample.dart';
import 'screens/login_screen.dart';


import 'package:kelim_ezberleme/services/word_service.dart';
import 'package:kelim_ezberleme/services/word_sample_service.dart';


Future<void> seedWords() async {
  final box = Hive.box<Word>('words');
  if (box.isNotEmpty) return;

  final raw = await rootBundle.loadString('assets/data/words.json');
  final list = jsonDecode(raw) as List;
  for (var e in list) {
    final w = Word(
      id: e['id'],
      engWord: e['engWord'],
      turWord: e['turWord'],
      exampleSentence: '',
      imagePath: e['imageAsset'],
    );
    await WordService.addWord(w);

    for (var sample in e['samples']) {
      final s = WordSample(
        id: DateTime.now().millisecondsSinceEpoch,
        wordId: w.id,
        sample: sample,
      );
      await WordSampleService.addSample(s);
    }
  }
}

Future<void> deleteInvalidWordAndProgress() async {
  var wordBox = Hive.box<Word>('words');
  var progressBox = Hive.box<AnswerProgress>('progress');

  // Büyük id'li kelimeleri sil
  final invalidWordKeys = wordBox.keys.where((k) => k is int && k > 0xFFFFFFFF).toList();
  print('Silinecek hatalı word id\'leri: $invalidWordKeys');
  for (var key in invalidWordKeys) {
    await wordBox.delete(key);
  }

  // Büyük id'li progress kayıtlarını sil
  final invalidProgressKeys = progressBox.keys.where((k) => k is int && k > 0xFFFFFFFF).toList();
  print('Silinecek hatalı progress id\'leri: $invalidProgressKeys');
  for (var key in invalidProgressKeys) {
    await progressBox.delete(key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(AnswerProgressAdapter());
  Hive.registerAdapter(WordSampleAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Word>('words');
  await Hive.openBox<AnswerProgress>('progress');
  await Hive.openBox<WordSample>('samples');

  await seedWords();

  runApp(KelimeEzberlemeApp());
}

class KelimeEzberlemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelime Ezberleme',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: ThemeMode.system,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
