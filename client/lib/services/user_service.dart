import 'dart:developer';
import 'package:client/models/employee_model.dart';
import 'package:client/models/user_model.dart';
import 'package:client/services/base_service.dart';
import 'package:client/utils/api_wrapper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService extends BaseService<UserModel> {
  UserService._();
  static final UserService instance = UserService._();

  Future<ApiResponse<List<UserModel<EmployeeModel>>>> getUsers() async {
    try {
      final response = await dio.get("/users");

      log("Raw Response getUsers: ${response.data}"); // ✅ TAMBAH LOG

      final json = response.data;
      final rawList = json["data"] as List;

      final users = rawList.map((item) {
        return UserModel<EmployeeModel>.fromJson(
          item,
          (employeeJson) =>
              EmployeeModel.fromJson(employeeJson as Map<String, dynamic>),
        );
      }).toList();

      return ApiResponse<List<UserModel<EmployeeModel>>>(
        message: json["message"] ?? "",
        success: json["success"] ?? false,
        data: users,
        error: json["error"],
      );
    } catch (e, s) {
      log("Error: Get Users Failed", error: e, stackTrace: s); // ✅ TAMBAH LOG

      return ApiResponse<List<UserModel<EmployeeModel>>>(
        message: 'Gagal memuat data: ${e.toString()}',
        success: false,
        data: null,
        error: e,
      );
    }
  }

  Future<ApiResponse<UserModel<EmployeeModel>>> getUser(int? userId) async {
    try {
      final storage = const FlutterSecureStorage();
      int? user;

      if (userId == null) {
        final userIdString = await storage.read(key: "userId");
        user = int.tryParse(userIdString ?? "");
      } else {
        user = userId;
      }

      log("Getting user with ID: $user"); // ✅ TAMBAH LOG

      final response = await dio.get("/user/$user");

      log("Raw Response getUser: ${response.data}"); // ✅ TAMBAH LOG

      return ApiResponse.fromJson(response.data, (json) {
        return UserModel.fromJson(json as Map<String, dynamic>, (employee) {
          return EmployeeModel.fromJson(employee as Map<String, dynamic>);
        });
      });
    } catch (e, s) {
      log("Error: Get User Failed", error: e, stackTrace: s); // ✅ TAMBAH LOG

      return ApiResponse<UserModel<EmployeeModel>>(
        message: 'Gagal memuat data: ${e.toString()}',
        success: false,
        data: null,
        error: e,
      );
    }
  }

  /// Update user data (untuk edit email, dll)
  Future<ApiResponse<UserModel<EmployeeModel>>> updateUser(
    int userId,
    Map<String, dynamic> data,
  ) async {
    try {
      log("=== UPDATE USER ===");
      log("User ID: $userId");
      log("Data: $data");

      final response = await dio.patch("/user/$userId", data: data);

      log("Response status: ${response.statusCode}");
      log("Response data: ${response.data}");

      return ApiResponse.fromJson(response.data, (json) {
        final userData = json as Map<String, dynamic>;

        // ✅ HANDLE NESTED DATA
        final actualData = userData['data'] ?? userData;

        return UserModel.fromJson(actualData, (employee) {
          return EmployeeModel.fromJson(employee as Map<String, dynamic>);
        });
      });
    } catch (e, s) {
      log("❌ Error: Update User Failed", error: e, stackTrace: s);

      return ApiResponse<UserModel<EmployeeModel>>(
        message: 'Gagal memperbarui data: ${e.toString()}',
        success: false,
        data: null,
        error: e,
      );
    }
  }
}
