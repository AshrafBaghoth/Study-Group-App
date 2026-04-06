import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

String explainLine(String line) {
  final s = line.trim();
  if (s.isEmpty) return 'Blank line';
  if (s.startsWith('//') || s.startsWith('/*') || s.startsWith('*')) return 'Comment: ${s.replaceAll(RegExp(r"^/+"), '')}';
  if (s.startsWith('import')) return 'Imports module or package: $s';
  if (s.startsWith('part') || s.startsWith('export')) return 'Library part/export directive: $s';
  if (s.startsWith('@')) return 'Annotation/Decorator: $s';
  if (s.startsWith('class ')) return 'Class declaration: $s';
  if ((s.contains(' class ') || s.startsWith('abstract class')) && s.endsWith('{')) return 'Class declaration (complex): $s';
  if (s.startsWith('final ') || s.startsWith('const ') || s.startsWith('var ')) return 'Variable declaration: $s';
  if (s.startsWith('return ')) return 'Return statement: $s';
  if (s.startsWith('void ') || s.startsWith('Future') || s.startsWith('Stream')) return 'Function/method declaration or async return type: $s';
  if (s.contains('Widget') || s.contains('build(')) return 'Flutter widget/typed UI code: $s';
  if (s.contains('Scaffold(') || s.contains('AppBar(') || s.contains('ListView')) return 'Flutter UI widget usage: $s';
  if (s.startsWith('if ') || s.startsWith('else') || s.startsWith('for ') || s.startsWith('while ')) return 'Control flow statement: $s';
  if (s.contains('=>') && s.trim().endsWith(';')) return 'Short arrow function/expression: $s';
  return 'Code: $s';
}

void main(List<String> args) async {
  final root = Directory.current;
  final lib = Directory('${root.path}${Platform.pathSeparator}lib');
  if (!lib.existsSync()) {
    print('lib/ directory not found in ${root.path}');
    return;
  }

  final outDir = Directory('${root.path}${Platform.pathSeparator}docs');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);
  final outFile = File('${outDir.path}${Platform.pathSeparator}project_explanation.pdf');

  final pdf = pw.Document();

  final dartFiles = lib
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in dartFiles) {
    final rel = file.path.replaceFirst('${root.path}${Platform.pathSeparator}', '').replaceAll('\\', '/');
    final lines = await file.readAsLines();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(18),
      build: (context) {
        final widgets = <pw.Widget>[];
        widgets.add(pw.Header(level: 1, child: pw.Text(rel)));
        for (var i = 0; i < lines.length; i++) {
          final code = lines[i];
          final explan = explainLine(code);
          widgets.add(pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 2, top: 2),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('L${(i + 1).toString().padLeft(3, '0')} | ${code.replaceAll('\t', '  ')}', style: pw.TextStyle(font: pw.Font.courier(), fontSize: 8)),
              pw.Text('    -> $explan', style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic)),
            ]),
          ));
        }
        return widgets;
      },
    ));
  }

  await outFile.writeAsBytes(await pdf.save());
  print('Generated PDF: ${outFile.path}');
}
