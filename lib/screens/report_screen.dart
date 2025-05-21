import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../models/word.dart';
import '../services/pdf_service.dart';
import '../services/progress_service.dart';
import '../models/answer_progress.dart';

// Bir kelimenin bir sonraki sınav tarihini hesaplar
DateTime nextDue(AnswerProgress p) {
  const intervals = [
    Duration(days: 1),
    Duration(days: 7),
    Duration(days: 30),
    Duration(days: 90),
    Duration(days: 180),
    Duration(days: 365),
  ];
  if (p.correctDates.isEmpty) {
    return DateTime.now();
  }
  final idx = (p.correctDates.length - 1).clamp(0, intervals.length - 1);
  return p.correctDates.last.add(intervals[idx]);
}

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final overall = overallProgressPercent().toStringAsFixed(1);
    final details = detailedProgress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analiz Raporu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              generateAndPrintReport();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kişisel İlerleme Raporu",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Genel başarı oranınızı ve kelime bazında ilerlemenizi buradan takip edebilirsiniz.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.timeline, size: 36, color: Colors.blue),
                title: const Text('Genel Başarı'),
                trailing: Text('$overall %', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (_, i) {
                  final entry = details[i];
                  final w = entry.key;
                  final pct = entry.value.toStringAsFixed(0);
                  final prog = ProgressService.getProgress(w.id);
                  final correctCount = prog.correctDates.length;
                  final due = nextDue(prog);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: ListTile(
                      leading: w.imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                w.imagePath!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blueGrey,
                              child: Icon(Icons.language, color: Colors.white, size: 28),
                            ),
                      title: Text(w.engWord, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Doğru cevap sayısı: $correctCount/6'),
                          Text('Sonraki sınav: ${due.day}/${due.month}/${due.year}'),
                        ],
                      ),
                      trailing: Text('$pct %', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
