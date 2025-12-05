import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:client/utils/constant.dart';

class EditTemplateScreen extends StatefulWidget {
  final Map template;

  const EditTemplateScreen({super.key, required this.template});

  @override
  State<EditTemplateScreen> createState() => _EditTemplateScreenState();
}

class _EditTemplateScreenState extends State<EditTemplateScreen> {
  late TextEditingController nameController;
  late TextEditingController contentController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.template["name"]);
    contentController = TextEditingController(text: widget.template["content"]);
  }

  Future<void> updateTemplate() async {
    try {
      setState(() => loading = true);

      Dio dio = Dio();
      final res = await dio.put(
        "${Constant.apiUrl}/templates/${widget.template["id"]}",
        data: {
          "name": nameController.text.trim(),
          "content": contentController.text.trim(),
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.data["message"] ?? "Berhasil update")),
      );

      Navigator.pop(context);

    } catch (e) {
      debugPrint("ERROR UPDATE TEMPLATE: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui template")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Template"),
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
                onPressed: loading ? null : updateTemplate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A8E8),
                ),
                child: Text(
                  loading ? "Menyimpan..." : "Update Template",
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
