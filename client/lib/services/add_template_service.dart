import 'package:client/models/list_template_model.dart';
import 'package:client/services/base_service.dart';
import 'package:flutter/material.dart';

class AddTemplateService extends BaseService<TemplateModel> {
  // Singleton pattern
  static final AddTemplateService _instance = AddTemplateService._internal();
  factory AddTemplateService() => _instance;
  AddTemplateService._internal();

  // ========================================
  // GET DEFAULT TEMPLATE CONTENT
  // ========================================
  String getDefaultTemplateContent() {
    return """
SURAT IZIN {{NAMA SURAT}}

Perihal: Izin {{Alasan}}
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

  // ========================================
  // CREATE NEW TEMPLATE
  // ========================================
  Future<Map<String, dynamic>> createTemplate({
    required String name,
    required String content,
  }) async {
    try {
      final response = await dio.post(
        '/templates',
        data: {
          'name': name.trim(),
          'content': content.trim(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Template berhasil dibuat',
          'data': response.data['data'] != null 
              ? TemplateModel.fromJson(response.data['data'])
              : null,
        };
      }

      return {
        'success': false,
        'message': 'Gagal membuat template',
        'data': null,
      };
    } catch (e) {
      debugPrint('❌ Error creating template: $e');
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'data': null,
      };
    }
  }

  // ========================================
  // VALIDATE TEMPLATE DATA
  // ========================================
  Map<String, dynamic> validateTemplate({
    required String name,
    required String content,
  }) {
    if (name.trim().isEmpty) {
      return {
        'valid': false,
        'message': 'Nama template tidak boleh kosong',
      };
    }

    if (name.trim().length < 3) {
      return {
        'valid': false,
        'message': 'Nama template minimal 3 karakter',
      };
    }

    if (name.trim().length > 100) {
      return {
        'valid': false,
        'message': 'Nama template maksimal 100 karakter',
      };
    }

    if (content.trim().isEmpty) {
      return {
        'valid': false,
        'message': 'Isi template tidak boleh kosong',
      };
    }

    if (content.trim().length < 10) {
      return {
        'valid': false,
        'message': 'Isi template minimal 10 karakter',
      };
    }

    return {
      'valid': true,
      'message': 'Validasi berhasil',
    };
  }

  // ========================================
  // CHECK IF TEMPLATE NAME EXISTS
  // ========================================
  Future<bool> isTemplateNameExists(String name) async {
    try {
      final response = await dio.get('/templates');

      if (response.statusCode == 200) {
        final templates = parseData(
          response.data,
          'data',
          TemplateModel.fromJson,
        );

        return templates.any(
          (t) => t.name.toLowerCase() == name.trim().toLowerCase(),
        );
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error checking template name: $e');
      return false;
    }
  }

  // ========================================
  // GET AVAILABLE PLACEHOLDERS
  // ========================================
  List<String> getAvailablePlaceholders() {
    return [
      '{{first_name}}',
      '{{last_name}}',
      '{{position}}',
      '{{department_name}}',
      '{{NAMA SURAT}}',
      '{{Alasan}}',
    ];
  }

  // ========================================
  // GET PLACEHOLDER DESCRIPTION
  // ========================================
  String getPlaceholderDescription(String placeholder) {
    final descriptions = {
      '{{first_name}}': 'Nama depan karyawan',
      '{{last_name}}': 'Nama belakang karyawan',
      '{{position}}': 'Jabatan karyawan',
      '{{department_name}}': 'Nama departemen',
      '{{NAMA SURAT}}': 'Jenis surat (Izin/Cuti/dll)',
      '{{Alasan}}': 'Alasan pengajuan',
    };

    return descriptions[placeholder] ?? 'Tidak ada deskripsi';
  }
}