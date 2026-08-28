import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'meal_service.dart';
import '../models/meal.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final MealService _mealService = MealService();

  Future<void> exportAsCsv() async {
    final allMealsMap = await _mealService.getAllMeals();
    
    // Header
    List<List<dynamic>> rows = [
      ["Datum", "Uhrzeit", "Mahlzeit", "Energie-Level", "Medikamente"]
    ];

    for (final dateKey in allMealsMap.keys) {
      final meals = allMealsMap[dateKey]!;
      for (final meal in meals) {
        rows.add([
          DateFormat('dd.MM.yyyy').format(meal.dateTime),
          meal.timeString,
          meal.type,
          meal.energyLevel ?? "-",
          meal.tookMeds == true ? "Ja" : (meal.tookMeds == false ? "Nein" : "-"),
        ]);
      }
    }

    String csv = const ListToCsvConverter(fieldDelimiter: ';').convert(rows);

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/mealbox_tagebuch.csv';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(path)],
      text: 'Hier ist mein MealBox Tagebuch (CSV-Format).',
    );
  }

  Future<void> exportAsPdf() async {
    final allMealsMap = await _mealService.getAllMeals();
    final pdf = pw.Document();

    List<List<String>> tableData = [
      ["Datum", "Uhrzeit", "Mahlzeit", "Energie", "Medikamente"]
    ];

    for (final dateKey in allMealsMap.keys) {
      final meals = allMealsMap[dateKey]!;
      for (final meal in meals) {
        tableData.add([
          DateFormat('dd.MM.yyyy').format(meal.dateTime),
          meal.timeString,
          meal.type,
          meal.energyLevel ?? "-",
          meal.tookMeds == true ? "Ja" : (meal.tookMeds == false ? "Nein" : "-"),
        ]);
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text("MealBox Tagebuch", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Erstellt am: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}"),
            pw.SizedBox(height: 20),
            if (tableData.length > 1)
              pw.TableHelper.fromTextArray(
                context: context,
                data: tableData,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5)),
                ),
              )
            else
              pw.Text("Bisher keine Mahlzeiten eingetragen.", style: const pw.TextStyle(color: PdfColors.grey)),
          ];
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/mealbox_tagebuch.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(path)],
      text: 'Hier ist mein MealBox Tagebuch (PDF-Format).',
    );
  }
}
