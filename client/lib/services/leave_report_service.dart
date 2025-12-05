import 'package:client/utils/api_wrapper.dart';
import 'package:client/utils/constant.dart';
import 'package:client/models/leave_report_model.dart';
import 'package:dio/dio.dart';

class LeaveReportService {
  LeaveReportService._();
  static final instance = LeaveReportService._();

  // Dio memakai baseUrl dari constant.dart
  final Dio dio = Dio(BaseOptions(
    baseUrl: Constant.apiUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<ApiResponse<LeaveReportResponse>> getDashboard() async {
    try {
      final response = await dio.get(
        "/izin-dashboard",
        options: Options(
          headers: {
            "Accept": "application/json",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      // ❗ Wrapper memiliki struktur:
      // { message, success, data, error }
      return ApiResponse<LeaveReportResponse>.fromJson(
        response.data,
        (rawJson) => LeaveReportResponse.fromJson(
          rawJson as Map<String, dynamic>,
        ),
      );
    } catch (e) {
      return ApiResponse(
        message: "Gagal memuat data dashboard",
        success: false,
        data: null,
        error: e.toString(),
      );
    }
  }
}
