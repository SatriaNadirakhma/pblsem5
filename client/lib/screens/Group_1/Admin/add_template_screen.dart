import 'package:flutter/material.dart';
import 'package:client/services/add_template_service.dart';

class AddTemplateScreen extends StatefulWidget {
  const AddTemplateScreen({super.key});

  @override
  State<AddTemplateScreen> createState() => _AddTemplateScreenState();
}

class _AddTemplateScreenState extends State<AddTemplateScreen> {
  final AddTemplateService _addTemplateService = AddTemplateService();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    
    // Load default template content from service
    contentController.text = _addTemplateService.getDefaultTemplateContent();
  }

  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // ========================================
  // SAVE TEMPLATE
  // ========================================
  Future<void> saveTemplate() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation using service
    final validation = _addTemplateService.validateTemplate(
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

    // Check if template name already exists
    setState(() => loading = true);
    final nameExists = await _addTemplateService.isTemplateNameExists(
      nameController.text,
    );

    if (nameExists) {
      setState(() => loading = false);
      _showSnackBar(
        'Nama template sudah digunakan',
        isError: true,
      );
      return;
    }

    // Confirm save
    final confirm = await _showConfirmDialog();
    if (confirm != true) {
      setState(() => loading = false);
      return;
    }

    try {
      final result = await _addTemplateService.createTemplate(
        name: nameController.text,
        content: contentController.text,
      );

      if (mounted) {
        _showSnackBar(
          result['message'] ?? 'Template berhasil dibuat',
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
      debugPrint("❌ ERROR SAVE TEMPLATE: $e");
      
      if (mounted) {
        _showSnackBar(
          "Gagal menyimpan template",
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
        content: Text(
          'Yakin ingin menyimpan template "${nameController.text}"?',
        ),
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
            child: const Text('Ya, Simpan'),
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
        title: const Text("Buat Template"),
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
                  hintText: 'Contoh: Surat Izin Sakit',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama template tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama template minimal 3 karakter';
                  }
                  if (value.trim().length > 100) {
                    return 'Nama template maksimal 100 karakter';
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
              // SAVE BUTTON
              // ========================================
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : saveTemplate,
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
                          "Simpan Template",
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