import 'package:flutter/material.dart';
import 'package:kelim_ezberleme/services/word_service.dart';
import '../models/word.dart';

class AddWordScreen extends StatefulWidget {
  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _engCtrl = TextEditingController();
  final _turCtrl = TextEditingController();
  final _sentenceCtrl = TextEditingController();

  @override
  void dispose() {
    _engCtrl.dispose();
    _turCtrl.dispose();
    _sentenceCtrl.dispose();
    super.dispose();
  }

  Future<void> _addWord() async {
    if (!_formKey.currentState!.validate()) return;

    final word = Word(
      id: DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF,
      engWord: _engCtrl.text.trim(),
      turWord: _turCtrl.text.trim(),
      exampleSentence: _sentenceCtrl.text.trim(),
      imagePath: null, // opsiyonel, daha sonra eklenebilir
    );

    await WordService.addWord(word);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kelime eklendi: ${word.engWord}')),
    );

    _formKey.currentState!.reset();
    _engCtrl.clear();
    _turCtrl.clear();
    _sentenceCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelime Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _engCtrl,
                decoration: const InputDecoration(labelText: 'İngilizce Kelime'),
                validator: (v) => v == null || v.isEmpty ? 'Boş bırakılamaz' : null,
              ),
              TextFormField(
                controller: _turCtrl,
                decoration: const InputDecoration(labelText: 'Türkçe Karşılığı'),
                validator: (v) => v == null || v.isEmpty ? 'Boş bırakılamaz' : null,
              ),
              TextFormField(
                controller: _sentenceCtrl,
                decoration: const InputDecoration(labelText: 'Örnek Cümle'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addWord,
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
