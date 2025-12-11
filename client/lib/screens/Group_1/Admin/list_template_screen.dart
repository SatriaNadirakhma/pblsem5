import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:client/models/list_template_model.dart';
import 'package:client/services/list_template_service.dart';

class ListTemplateScreen extends StatefulWidget {
  const ListTemplateScreen({super.key});

  @override
  State<ListTemplateScreen> createState() => _ListTemplateScreenState();
}

class _ListTemplateScreenState extends State<ListTemplateScreen> {
  final TemplateService _templateService = TemplateService();
  
  List<TemplateModel> templates = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTemplates();
  }

  // ========================================
  // LOAD TEMPLATES
  // ========================================
  Future<void> loadTemplates() async {
    setState(() => loading = true);

    try {
      final data = await _templateService.getAllTemplates();
      
      setState(() {
        templates = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("❌ ERROR LOAD TEMPLATE: $e");
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat template'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      setState(() => loading = false);
    }
  }

  // ========================================
  // DELETE TEMPLATE
  // ========================================
  Future<void> deleteTemplate(TemplateModel template) async {
    // Cek jika template adalah default
    if (template.name == "Surat Izin Default") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Template default tidak bisa dihapus'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Confirm deletion
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Yakin ingin menghapus template "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final success = await _templateService.deleteTemplate(template.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success 
                  ? 'Template berhasil dihapus' 
                  : 'Gagal menghapus template',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );

        if (success) {
          loadTemplates(); // Reload list
        }
      }
    } catch (e) {
      debugPrint("❌ ERROR DELETE TEMPLATE: $e");
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus template'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ========================================
  // BUILD UI
  // ========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Template"),
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.push('/admin/template/add');
              loadTemplates(); // Reload after add
            },
            tooltip: 'Tambah Template',
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : templates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada template',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadTemplates,
                  child: ListView.builder(
                    itemCount: templates.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      final isDefault = template.name == "Surat Izin Default";

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          
                          // ========================================
                          // TITLE & SUBTITLE
                          // ========================================
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  template.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'DEFAULT',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              template.content.length > 80
                                  ? '${template.content.substring(0, 80)}...'
                                  : template.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // ========================================
                          // ACTION BUTTONS
                          // ========================================
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // EDIT BUTTON
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: isDefault 
                                      ? Colors.grey 
                                      : Colors.blue,
                                ),
                                onPressed: isDefault
                                    ? null
                                    : () async {
                                        await context.push(
                                          "/admin/template/edit",
                                          extra: template.toJson(),
                                        );
                                        loadTemplates(); // Reload after edit
                                      },
                                tooltip: isDefault
                                    ? 'Template default tidak bisa diedit'
                                    : 'Edit template',
                              ),

                              // DELETE BUTTON
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: isDefault 
                                      ? Colors.grey 
                                      : Colors.red,
                                ),
                                onPressed: isDefault
                                    ? null
                                    : () => deleteTemplate(template),
                                tooltip: isDefault
                                    ? 'Template default tidak bisa dihapus'
                                    : 'Hapus template',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}