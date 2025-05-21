import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'report_service.dart';
import '../models/word.dart';
import '../services/progress_service.dart';

/// PDF belgesi üretir ve doğrudan yazdırma veya paylaşma penceresini açar.
Future<void> generateAndPrintReport() async {
  final pdf = pw.Document();
  final overall = overallProgressPercent().toStringAsFixed(1);
  final details = detailedProgress();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(level: 0, child: pw.Text('Analiz Raporu', style: pw.TextStyle(fontSize: 24))),
        pw.Paragraph(text: 'Genel Başarı: $overall %'),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ['Kelime', 'Doğru Sayısı', 'Yüzde'],
          data: details.map((e) {
            final Word w = e.key;
            final pct = e.value.toStringAsFixed(0);
            final count = ProgressService.getProgress(w.id).correctDates.length;
            return [w.engWord, '$count/6', '$pct %'];
          }).toList(),
        ),
      ],
    ),
  );

  // PDF'i yazdır veya paylaş
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
