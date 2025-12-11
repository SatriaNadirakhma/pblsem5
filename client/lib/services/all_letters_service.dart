import 'dart:io';
import 'package:client/models/all_letters_model.dart';
import 'package:client/services/base_service.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:excel/excel.dart';

class AllLettersService extends BaseService<LetterModel> {
  // Singleton pattern
  static final AllLettersService _instance = AllLettersService._internal();
  factory AllLettersService() => _instance;
  AllLettersService._internal();

  // ========================================
  // MONTH NAMES
  // ========================================
  static const List<String> monthNames = [
    "Januari", "Februari", "Maret", "April", "Mei", "Juni",
    "Juli", "Agustus", "September", "Oktober", "November", "Desember",
  ];

  // ========================================
  // PARSE DATE
  // ========================================
  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    
    if (value is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } catch (_) {
        return null;
      }
    }
    
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        try {
          final sep = value.contains('-')
              ? '-'
              : value.contains('/')
              ? '/'
              : null;
          if (sep != null) {
            final parts = value.split(sep);
            if (parts.length >= 3) {
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              return DateTime(year, month, day);
            }
          }
        } catch (_) {
          return null;
        }
      }
    }
    
    return null;
  }

  // ========================================
  // FILTER RAW DATA BY MONTH
  // ========================================
  List<dynamic> filterRawDataByMonth(
    List<dynamic> letters,
    int? selectedMonth,
  ) {
    if (selectedMonth == null) return letters;

    return letters.where((item) {
      List<String> dates = item['cuti_dates']
          .toString()
          .split(',')
          .map((e) => e.trim())
          .toList();

      bool match = false;

      for (var d in dates) {
        final parsed = parseDate(d);
        if (parsed != null && parsed.month == selectedMonth) {
          match = true;
          break;
        }
      }

      return match;
    }).toList();
  }

  // ========================================
  // EXPAND LETTERS (1 CARD = 1 CUTI)
  // ========================================
  List<Map<String, dynamic>> expandLetters(
    List<dynamic> filteredList,
    int? selectedMonth,
  ) {
    List<Map<String, dynamic>> expandedList = [];

    for (var item in filteredList) {
      final cutiList = (item['cuti_list'] ?? '')
          .toString()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final cutiDates = (item['cuti_dates'] ?? '')
          .toString()
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (int i = 0; i < cutiList.length; i++) {
        final dateStr = i < cutiDates.length ? cutiDates[i] : null;
        final parsed = parseDate(dateStr);

        // Jika filter bulan aktif → hanya tampilkan cuti yang cocok
        if (selectedMonth != null) {
          if (parsed == null || parsed.month != selectedMonth) {
            continue; // skip cuti bulan lain
          }
        }

        expandedList.add({
          'employee_name': item['employee_name'],
          'department_name': item['department_name'],
          'cuti_type': cutiList[i],
          'cuti_date': dateStr ?? '-',
        });
      }
    }

    return expandedList;
  }

  // ========================================
  // EXPORT TO EXCEL (NEW - like Employee Export)
  // ========================================
  Future<String?> exportToExcel(
    List<Map<String, dynamic>> letters,
    int? selectedMonth,
  ) async {
    try {
      // 1. Create Excel
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Laporan Cuti'];

      // 2. Style untuk header
      CellStyle headerStyle = CellStyle(
        backgroundColorHex: ExcelColor.fromHexString('#1B7FA8'),
        fontColorHex: ExcelColor.white,
        bold: true,
        fontSize: 12,
      );

      // 3. Header columns
      List<String> headers = [
        'No',
        'Nama Karyawan',
        'Departemen',
        'Jenis Cuti',
        'Tanggal Cuti',
      ];

      // 4. Insert header
      for (var i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = headerStyle;
      }

      // 5. Insert data
      for (var i = 0; i < letters.length; i++) {
        var letter = letters[i];
        var row = i + 1;

        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
            .value = IntCellValue(i + 1);

        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
            .value = TextCellValue(letter['employee_name'] ?? 'Tanpa Nama');

        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
            .value = TextCellValue(letter['department_name'] ?? '-');

        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
            .value = TextCellValue(letter['cuti_type'] ?? '-');

        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
            .value = TextCellValue(letter['cuti_date'] ?? '-');
      }

      // 6. Auto-size columns
      for (var i = 0; i < headers.length; i++) {
        sheetObject.setColumnWidth(i, 20);
      }

      // 7. Save file
      var fileBytes = excel.save();
      if (fileBytes == null) {
        throw Exception('Failed to generate Excel file');
      }

      // 8. Get file path with fallback
      String? filePath;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final monthSuffix = selectedMonth != null 
          ? '_${monthNames[selectedMonth - 1]}'
          : '';
      final fileName = 'Laporan_Cuti$monthSuffix\_$timestamp.xlsx';

      if (Platform.isAndroid) {
        // ✅ TRY MULTIPLE LOCATIONS
        try {
          // Try 1: Request storage permission
          var status = await Permission.storage.status;
          debugPrint('Storage permission status: $status');

          if (!status.isGranted) {
            status = await Permission.storage.request();
            debugPrint('After request: $status');
          }

          // Try 2: manageExternalStorage for Android 11+
          if (!status.isGranted) {
            var manageStatus = await Permission.manageExternalStorage.status;
            debugPrint('Manage storage status: $manageStatus');

            if (!manageStatus.isGranted) {
              manageStatus = await Permission.manageExternalStorage.request();
              debugPrint('After manage request: $manageStatus');
            }

            if (manageStatus.isGranted) {
              status = PermissionStatus.granted;
            }
          }

          // ✅ FALLBACK: Use app directory if permission denied
          if (status.isGranted || status.isLimited) {
            // Try Download folder
            final downloadDir = Directory('/storage/emulated/0/Download');
            if (await downloadDir.exists()) {
              filePath = '${downloadDir.path}/$fileName';
              debugPrint('✅ Using Download folder: $filePath');
            }
          }

          // ✅ FALLBACK 2: Use Documents folder
          if (filePath == null) {
            final docsDir = Directory('/storage/emulated/0/Documents');
            if (!await docsDir.exists()) {
              await docsDir.create(recursive: true);
            }
            filePath = '${docsDir.path}/$fileName';
            debugPrint('✅ Using Documents folder: $filePath');
          }
        } catch (e) {
          debugPrint('⚠️ External storage failed: $e');
        }

        // ✅ FALLBACK 3: Use app internal storage
        if (filePath == null) {
          final appDir = await getApplicationDocumentsDirectory();
          filePath = '${appDir.path}/$fileName';
          debugPrint('✅ Using app directory: $filePath');
        }
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        filePath = '${directory.path}/$fileName';
      } else {
        final directory = await getDownloadsDirectory();
        filePath = '${directory!.path}/$fileName';
      }

      // 9. Write file
      final file = File(filePath);
      await file.writeAsBytes(fileBytes, flush: true);

      debugPrint('✅ Excel file saved: $filePath');
      debugPrint('✅ File exists: ${await file.exists()}');
      debugPrint('✅ File size: ${await file.length()} bytes');

      return filePath;
    } catch (e, stackTrace) {
      debugPrint('❌ Error exporting Excel: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  // ========================================
  // OPEN FILE
  // ========================================
  Future<void> openFile(String filePath) async {
    try {
      debugPrint('Opening file: $filePath');
      final result = await OpenFilex.open(filePath);
      debugPrint('Open result: ${result.type} - ${result.message}');
    } catch (e) {
      debugPrint('❌ Error opening file: $e');
    }
  }

  // ========================================
  // GET MONTH NAME
  // ========================================
  String getMonthName(int? month) {
    if (month == null || month < 1 || month > 12) {
      return "Semua Bulan";
    }
    return monthNames[month - 1];
  }
}