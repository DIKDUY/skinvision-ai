import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  /// =====================================
  /// Local Development
  /// Setelah backend berhasil deploy ke Render,
  /// ganti URL di bawah ini.
  /// =====================================

  static const String baseUrl = "http://192.168.0.27:8000";

  // Contoh setelah deploy:
  // static const String baseUrl =
  //     "https://skinvision-ai-backend.onrender.com";

  /// =====================================

  static Future<Map<String, dynamic>> predictDisease(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/predict"),
      );

      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile.path),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 90),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception(
        "Server Error (${response.statusCode}) : ${response.body}",
      );
    } on SocketException {
      throw Exception(
        "Tidak dapat terhubung ke server. Pastikan backend sedang berjalan.",
      );
    } on HttpException {
      throw Exception("Kesalahan jaringan.");
    } on FormatException {
      throw Exception("Response server tidak valid.");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  static String getShapUrl(String path) {
    if (path.isEmpty) {
      return "";
    }

    return "$baseUrl/$path";
  }
}
