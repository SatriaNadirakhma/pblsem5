import 'package:client/models/list_template_model.dart';
import 'package:client/services/base_service.dart';
import 'package:flutter/material.dart';

class EditTemplateService extends BaseService<TemplateModel> {
  // Singleton pattern
  static final EditTemplateService _instance = EditTemplateService._internal();
  factory EditTemplateService() => _instance;
  EditTemplateService._internal();

  // ========================================
  // UPDATE TEMPLATE
  // ========================================
  Future<Map<String, dynamic>> updateTemplate({
    required int id,
    required String name,
    required String content,
  }) async {
    try {
      final response = await dio.put(
        '/templates/$id',
        data: {
          'name': name.trim(),
          'content': content.trim(),
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Template berhasil diperbarui',
          'data': response.data['data'] != null 
              ? TemplateModel.fromJson(response.data['data'])
              : null,
        };
      }

      return {
        'success': false,
        'message': 'Gagal memperbarui template',
        'data': null,
      };
    } catch (e) {
      debugPrint('❌ Error updating template: $e');
      
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'data': null,
      };
    }
  }

  // ========================================
  // GET TEMPLATE BY ID (untuk validasi)
  // ========================================
  Future<TemplateModel?> getTemplateById(int id) async {
    try {
      final response = await dio.get('/templates/$id');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return TemplateModel.fromJson(data);
      }

      debugPrint('❌ Failed to load template: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('❌ Error loading template: $e');
      return null;
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
}