import 'package:flutter/material.dart';
import 'package:client/services/all_letters_service.dart';

class AllLettersPage extends StatefulWidget {
  final List<dynamic> letters;

  const AllLettersPage({super.key, required this.letters});

  @override
  State<AllLettersPage> createState() => _AllLettersPageState();
}

class _AllLettersPageState extends State<AllLettersPage> {
  final AllLettersService _service = AllLettersService();
  int? selectedMonth;

  @override
  Widget build(BuildContext context) {
    // Filter menggunakan service
    List<dynamic> filteredList = _service.filterRawDataByMonth(
      widget.letters,
      selectedMonth,
    );

    // Expand menggunakan service
    List<Map<String, dynamic>> expandedList = _service.expandLetters(
      filteredList,
      selectedMonth,
    );

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
                    onPressed: () async {
                      // ✅ UPDATED: Call new export method
                      final filePath = await _service.exportToExcel(
                        expandedList,
                        selectedMonth,
                      );
                      
                      if (filePath != null) {
                        await _service.openFile(filePath);
                      }
                    },
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
                            _service.getMonthName(selectedMonth),
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
                        return monthFilterOption(
                          i + 1,
                          AllLettersService.monthNames[i],
                        );
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
}