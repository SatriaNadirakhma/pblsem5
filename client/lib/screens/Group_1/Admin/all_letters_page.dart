import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:client/utils/constant.dart';

<<<<<<< HEAD
=======

>>>>>>> origin/MiniGroup-1
class AllLettersPage extends StatefulWidget {
  final List<dynamic> letters;

  const AllLettersPage({super.key, required this.letters});

  @override
  State<AllLettersPage> createState() => _AllLettersPageState();
}

class _AllLettersPageState extends State<AllLettersPage> {
  int? selectedMonth;

  final List<String> monthNames = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  Future<void> exportToExcel() async {
    String baseUrl =
<<<<<<< HEAD
        "https://collene-eternal-luba.ngrok-free.dev/api/export-approved-letters";
=======
        "${Constant.apiUrl}/export-approved-letters";
>>>>>>> origin/MiniGroup-1

    String url = selectedMonth != null
        ? "$baseUrl?month=$selectedMonth"
        : baseUrl;

    try {
      Dio dio = Dio();

      Directory dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/laporan_cuti_disetujui.xlsx";

      await dio.download(
        url,
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      await OpenFilex.open(filePath);
    } catch (e) {
      debugPrint("ERROR EXPORT: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredList = selectedMonth == null
        ? widget.letters
        : widget.letters.where((item) {
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

    // ============================
    // EXPAND MENJADI 1 CARD = 1 CUTI
    // ============================
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan Semua Karyawan Cuti',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // HEADER EXPORT + FILTER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: exportToExcel,
                    icon: const Icon(Icons.download, size: 20),
                    label: const Text(
                      "Export",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => showMonthFilterSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.filter_list),
                          const SizedBox(width: 6),
                          Text(
                            selectedMonth == null
                                ? "Semua Bulan"
                                : monthNames[selectedMonth! - 1],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LIST DATA YANG SUDAH DIEKSPANSI
          Expanded(
            child: ListView.builder(
              itemCount: expandedList.length,
              itemBuilder: (context, index) {
                final item = expandedList[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ${item['employee_name'] ?? 'Tanpa Nama'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          "Departemen: ${item['department_name'] ?? '-'}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Jenis Cuti: ${item['cuti_type']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Tanggal: ${item['cuti_date']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // FOOTER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade200,
            child: Text(
              "Total Data Ditampilkan: ${expandedList.length}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // BOTTOM SHEET FILTER BULAN
  // ============================
  void showMonthFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Filter Berdasarkan Bulan",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      monthFilterOption(null, "Semua Bulan"),
                      ...List.generate(12, (i) {
                        return monthFilterOption(i + 1, monthNames[i]);
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

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

  Widget monthFilterOption(int? monthValue, String label) {
    return ListTile(
      title: Text(label),
      trailing: selectedMonth == monthValue
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() => selectedMonth = monthValue);
        Navigator.pop(context);
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/MiniGroup-1
