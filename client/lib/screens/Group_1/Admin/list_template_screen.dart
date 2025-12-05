import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:client/utils/constant.dart';
import 'package:go_router/go_router.dart';

class ListTemplateScreen extends StatefulWidget {
  const ListTemplateScreen({super.key});

  @override
  State<ListTemplateScreen> createState() => _ListTemplateScreenState();
}

class _ListTemplateScreenState extends State<ListTemplateScreen> {
  List<dynamic> templates = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    try {
      Dio dio = Dio();
      final res = await dio.get("${Constant.apiUrl}/templates");

      setState(() {
        templates = res.data["data"];
        loading = false;
      });
    } catch (e) {
      debugPrint("ERROR LOAD TEMPLATE: $e");
      setState(() => loading = false);
    }
  }

  Future<void> deleteTemplate(int id) async {
    try {
      Dio dio = Dio();
      final res = await dio.delete("${Constant.apiUrl}/templates/$id");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.data["message"])),
      );

      loadTemplates();
    } catch (e) {
      debugPrint("ERROR DELETE TEMPLATE: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menghapus template")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Template"),
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : templates.isEmpty
              ? const Center(child: Text("Belum ada template"))
              : ListView.builder(
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final item = templates[index];
                    final bool isDefault = item["name"] == "Surat Izin Default";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          item["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          (item["content"] ?? "")
                              .toString()
                              .replaceAll("\n", " ")
                              .substring(
                                0,
                                item["content"]
                                    .toString()
                                    .length
                                    .clamp(0, 80),
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // ====== ACTION BUTTONS ======
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // --- EDIT BUTTON (disabled untuk default) ---
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: isDefault ? Colors.grey : Colors.blue,
                              ),
                              onPressed: isDefault
                                  ? null
                                  : () => context.push(
                                        "/admin/template/edit",
                                        extra: item,
                                      ),
                            ),

                            // --- DELETE BUTTON (disabled untuk default) ---
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: isDefault ? Colors.grey : Colors.red,
                              ),
                              onPressed: isDefault
                                  ? null
                                  : () => deleteTemplate(item["id"]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
