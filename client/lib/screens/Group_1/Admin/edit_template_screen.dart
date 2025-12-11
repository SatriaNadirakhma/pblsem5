import 'package:flutter/material.dart';
import 'package:client/models/list_template_model.dart';
import 'package:client/services/edit_template_service.dart';

class EditTemplateScreen extends StatefulWidget {
  final Map<String, dynamic> template;

  const EditTemplateScreen({super.key, required this.template});

  @override
  State<EditTemplateScreen> createState() => _EditTemplateScreenState();
}

class _EditTemplateScreenState extends State<EditTemplateScreen> {
  final EditTemplateService _editTemplateService = EditTemplateService();
  
  late TextEditingController nameController;
  late TextEditingController contentController;
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  late TemplateModel templateModel;

  @override
  void initState() {
    super.initState();
    
    // Convert Map to TemplateModel
    templateModel = TemplateModel.fromJson(widget.template);
    
    nameController = TextEditingController(text: templateModel.name);
    contentController = TextEditingController(text: templateModel.content);
  }

  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // ========================================
  // UPDATE TEMPLATE
  // ========================================
  Future<void> updateTemplate() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation using service
    final validation = _editTemplateService.validateTemplate(
      name: nameController.text,
      content: contentController.text,
    );

    if (validation['valid'] != true) {
      _showSnackBar(
        validation['message'] ?? 'Validasi gagal',
        isError: true,
      );
      return;
    }

    // Confirm update
    final confirm = await _showConfirmDialog();
    if (confirm != true) return;

    setState(() => loading = true);

    try {
      final result = await _editTemplateService.updateTemplate(
        id: templateModel.id,
        name: nameController.text,
        content: contentController.text,
      );

      if (mounted) {
        _showSnackBar(
          result['message'] ?? 'Template berhasil diperbarui',
          isError: !result['success'],
        );

        if (result['success']) {
          // Wait a bit for snackbar to show
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pop(context, true); // Return true to indicate success
          }
        }
      }
    } catch (e) {
      debugPrint("❌ ERROR UPDATE TEMPLATE: $e");
      
      if (mounted) {
        _showSnackBar(
          "Gagal memperbarui template",
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // ========================================
  // SHOW CONFIRMATION DIALOG
  // ========================================
  Future<bool?> _showConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin memperbarui template ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A8E8),
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Update'),
          ),
        ],
      ),
    );
  }

  // ========================================
  // SHOW SNACKBAR
  // ========================================
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ========================================
  // BUILD UI
  // ========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Template"),
        backgroundColor: const Color(0xFF00A8E8),
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ========================================
              // TEMPLATE NAME FIELD
              // ========================================
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Template",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama template tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama template minimal 3 karakter';
                  }
                  return null;
                },
                enabled: !loading,
              ),

              const SizedBox(height: 20),

              // ========================================
              // TEMPLATE CONTENT FIELD
              // ========================================
              Expanded(
                child: TextFormField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: "Isi Template",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Isi template tidak boleh kosong';
                    }
                    if (value.trim().length < 10) {
                      return 'Isi template minimal 10 karakter';
                    }
                    return null;
                  },
                  enabled: !loading,
                ),
              ),

              const SizedBox(height: 20),

              // ========================================
              // UPDATE BUTTON
              // ========================================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : updateTemplate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8E8),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: loading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("Menyimpan..."),
                          ],
                        )
                      : const Text(
                          "Update Template",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}