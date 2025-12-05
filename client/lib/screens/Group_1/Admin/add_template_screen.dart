import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:client/utils/constant.dart';

class AddTemplateScreen extends StatefulWidget {
  const AddTemplateScreen({super.key});

  @override
  State<AddTemplateScreen> createState() => _AddTemplateScreenState();
}

class _AddTemplateScreenState extends State<AddTemplateScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    // langsung isi template default
    contentController.text = _letterDefault();
  }

  // ======================================
  // TEMPLATE DEFAULT — langsung di Flutter
  // ======================================
  String _letterDefault() {
    return """
SURAT IZIN {{NAMA SURAT}}

Perihal: Izin {{NAMA SURAT}}
Lampiran: -

Kepada Yth. HRD
Di 
Tempat.

Dengan hormat,

Saya yang bertanda tangan di bawah ini:

Nama        : {{first_name}} {{last_name}}
Jabatan     : {{position}}
Departemen  : {{department_name}}

Bermaksud untuk mengajukan surat permohonan cuti tahunan pada tanggal [dd/mm/yyyy] hingga [dd/mm/yyyy].

Demikian surat izin ini saya ajukan. Atas pengertiannya, saya ucapkan terima kasih.

Hormat saya

{{first_name}} {{last_name}}
""";
  }

  // =============================
  // SIMPAN TEMPLATE
  // =============================
  Future<void> saveTemplate() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama template wajib diisi")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      Dio dio = Dio();
      final response = await dio.post(
        "${Constant.apiUrl}/templates",
        data: {
          "name": nameController.text.trim(),
          "content": contentController.text.trim(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data["message"] ?? "Berhasil")),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("ERROR SAVE TEMPLATE: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan template")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Template"),
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nama Template",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: "Isi Template",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : saveTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A8E8),
                ),
                child: Text(
                  loading ? "Menyimpan..." : "Simpan",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
