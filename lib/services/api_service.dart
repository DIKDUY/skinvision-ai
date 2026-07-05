import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  /// =====================================
  /// Local FastAPI
  /// =====================================

  // Ganti nanti setelah deploy ke Render
  static const String baseUrl = "http://192.168.0.27:8000";

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
        final data = jsonDecode(response.body);

        return data;
      } else {
        throw Exception("Server Error (${response.statusCode})");
      }
    } on SocketException {
      throw Exception("Tidak dapat terhubung ke server.");
    } on HttpException {
      throw Exception("Kesalahan jaringan.");
    } on FormatException {
      throw Exception("Response server tidak valid.");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static String getShapUrl(String path) {
    if (path.isEmpty) {
      return "";
    }

    return "$baseUrl/$path";
  }
}
