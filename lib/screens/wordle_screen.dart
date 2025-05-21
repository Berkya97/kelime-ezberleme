// lib/screens/wordle_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kelim_ezberleme/services/word_service.dart';
import 'package:kelim_ezberleme/services/progress_service.dart';

/// Wordle tarzı bulmaca ekranı
/// Öğrenilmiş kelimeler yerine en az bir kez doğru işaretlenmiş (>=1) 5 harfli kelimeleri kullanır.
class WordleScreen extends StatefulWidget {
  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  static const int maxRows = 6;
  static const int wordLength = 5;

  late final List<String> _allowedWords;
  late final String _target;
  final List<String> _guesses = [];
  String _current = '';

  @override
  void initState() {
    super.initState();
    // En az bir kez doğru işaretlenmiş ve 5 harfli kelimeler havuzu
    _allowedWords = WordService.getAll()
        .where((w) {
      final prog = ProgressService.getProgress(w.id);
      return prog.correctDates.isNotEmpty && w.engWord.length == wordLength;
    })
        .map((w) => w.engWord.toUpperCase())
        .toList();
    if (_allowedWords.isEmpty) {
      _allowedWords.add('FLUTT'); // placeholder kelime
    }
    // Rastgele hedef seç
    _target = (_allowedWords..shuffle()).first;
  }

  void _onKeyTap(String key) {
    if (_guesses.length >= maxRows) return;
    setState(() {
      if (key == 'ENTER') {
        if (_current.length == wordLength && _allowedWords.contains(_current)) {
          _guesses.add(_current);
          // Geri bildirim
          if (_current == _target) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tebrikler! Doğru tahmin.'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 1),
              ),
            );
          } else if (_guesses.length + 1 == maxRows) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cevap: $_target'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          }
          _current = '';
        }
      } else if (key == 'BACK') {
        if (_current.isNotEmpty) _current = _current.substring(0, _current.length - 1);
      } else {
        if (_current.length < wordLength) _current += key;
      }
    });
  }

  Color _getColor(String guess, int index) {
    final letter = guess[index];
    if (_target[index] == letter) return Colors.green;
    if (_target.contains(letter)) return Colors.yellow;
    return Colors.grey;
  }

  Widget _buildGrid() {
    return Column(
      children: List.generate(maxRows, (row) {
        final guess = row < _guesses.length
            ? _guesses[row]
            : (row == _guesses.length ? _current.padRight(wordLength) : ''.padRight(wordLength));
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(wordLength, (i) {
            final char = guess[i];
            final bg = row < _guesses.length ? _getColor(guess, i) : Colors.transparent;
            return Container(
              margin: const EdgeInsets.all(4),
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 2),
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(char, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            );
          }),
        );
      }),
    );
  }

  Widget _buildKeyboard() {
    const rows = [
      'QWERTYUIOP',
      'ASDFGHJKL',
      'ZXCVBNM'
    ];

    return Column(
      children: rows.map((row) {
        // wrap ile alt satıra geçsin ve overflow olmasın
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            // backspace düğmesi
            ElevatedButton(
              onPressed: () => _onKeyTap('BACK'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Icon(Icons.backspace),
            ),
            // alfabe tuşları
            ...row.split('').map((key) {
              return ElevatedButton(
                onPressed: () => _onKeyTap(key),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              );
            }).toList(),
            // enter düğmesi
            ElevatedButton(
              onPressed: () => _onKeyTap('ENTER'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(72, 48),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('ENTER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wordle Bulmaca')),
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
                children: [
                  const Text(
                    "Wordle Bulmaca",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "5 harfli kelimeyi 6 denemede bulmaya çalışın.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildGrid(),
                  const SizedBox(height: 24),
                  _buildKeyboard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
