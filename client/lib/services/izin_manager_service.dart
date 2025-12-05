import 'package:dio/dio.dart';
import 'package:client/utils/constant.dart';
import '../models/izin_manager_model.dart';

class IzinService {
  final Dio _dio = Dio();

  // ---------------- DASHBOARD ----------------
  Future<Map<String, int>> loadDashboard() async {
    final res = await _dio.get("${Constant.apiUrl}/izin-dashboard");

    return {
      "approvedOrRejected":
          res.data["data"]["total_letters_approved_or_rejected"],
      "pending": res.data["data"]["total_letters_pending"],
    };
  }

  // ---------------- LIST IZIN ----------------
  Future<List<IzinModel>> loadIzinList() async {
    final res = await _dio.get("${Constant.apiUrl}/izin-list");

    final List raw = (res.data["data"] as List?) ?? [];

    return raw.map((item) => IzinModel.fromJson(item)).toList();
  }

  // ---------------- UPDATE STATUS ----------------
  Future<bool> updateStatus(int id, int newStatus) async {
    final res = await _dio.post(
      "${Constant.apiUrl}/izin-update/$id",
      data: {"status": newStatus},
    );

    return res.data["success"] == true;
  }
}
