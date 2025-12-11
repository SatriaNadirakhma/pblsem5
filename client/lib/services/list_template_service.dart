import 'package:client/models/list_template_model.dart';
import 'package:client/services/base_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TemplateService extends BaseService<TemplateModel> {
  // Singleton pattern
  static final TemplateService _instance = TemplateService._internal();
  factory TemplateService() => _instance;
  TemplateService._internal();

  // ========================================
  // GET ALL TEMPLATES
  // ========================================
  Future<List<TemplateModel>> getAllTemplates() async {
    try {
      final response = await dio.get('/templates');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Parse using BaseService method
        return parseData(
          data,
          'data',
          TemplateModel.fromJson,
        );
      }

      debugPrint('❌ Failed to load templates: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error loading templates: $e');
      return [];
    }
  }

  // ========================================
  // GET SINGLE TEMPLATE BY ID
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
  // CREATE NEW TEMPLATE
  // ========================================
  Future<TemplateModel?> createTemplate({
    required String name,
    required String content,
  }) async {
    try {
      final response = await dio.post(
        '/templates',
        data: {
          'name': name,
          'content': content,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data['data'];
        return TemplateModel.fromJson(data);
      }

      debugPrint('❌ Failed to create template: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('❌ Error creating template: $e');
      return null;
    }
  }

  // ========================================
  // UPDATE TEMPLATE
  // ========================================
  Future<TemplateModel?> updateTemplate({
    required int id,
    String? name,
    String? content,
  }) async {
    try {
      final response = await dio.put(
        '/templates/$id',
        data: {
          if (name != null) 'name': name,
          if (content != null) 'content': content,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return TemplateModel.fromJson(data);
      }

      debugPrint('❌ Failed to update template: ${response.statusCode}');
      return null;
    } catch (e) {
      debugPrint('❌ Error updating template: $e');
      return null;
    }
  }

  // ========================================
  // DELETE TEMPLATE
  // ========================================
  Future<bool> deleteTemplate(int id) async {
    try {
      final response = await dio.delete('/templates/$id');

      if (response.statusCode == 200) {
        debugPrint('✅ Template deleted successfully');
        return true;
      }

      debugPrint('❌ Failed to delete template: ${response.statusCode}');
      return false;
    } catch (e) {
      debugPrint('❌ Error deleting template: $e');
      return false;
    }
  }

  // ========================================
  // GET DEFAULT TEMPLATE
  // ========================================
  Future<TemplateModel?> getDefaultTemplate() async {
    try {
      final templates = await getAllTemplates();
      
      return templates.firstWhere(
        (t) => t.name == "Surat Izin Default",
        orElse: () => templates.isNotEmpty 
            ? templates.first 
            : throw Exception('No templates found'),
      );
    } catch (e) {
      debugPrint('❌ Error getting default template: $e');
      return null;
    }
  }
}