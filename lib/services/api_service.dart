import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/diagnosis_model.dart';

class ApiService {
  static const String baseUrl = "https://dikikiki-skinvision-ai.hf.space";

  /// ===============================
  /// MAIN PREDICTION FUNCTION
  /// ===============================

  static Future<DiagnosisModel> predictDisease(File imageFile) async {
    try {
      // ===============================
      // STEP 1
      // Upload image
      // ===============================

      final uploadRequest = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/gradio_api/upload"),
      );

      // User-Agent untuk identitas aplikasi
      uploadRequest.headers.addAll({"User-Agent": "SkinVisionAI-Mobile-App"});

      uploadRequest.files.add(
        await http.MultipartFile.fromPath("files", imageFile.path),
      );

      final uploadResponse = await uploadRequest.send().timeout(
        const Duration(seconds: 90),
      );

      final uploadBody = await uploadResponse.stream.bytesToString();

      if (uploadResponse.statusCode != 200) {
        throw Exception("Upload gagal: $uploadBody");
      }

      print("Upload berhasil");

      final uploadedPath = jsonDecode(uploadBody)[0];

      // ===============================
      // STEP 2
      // Call Gradio Predict
      // ===============================

      final predictResponse = await http
          .post(
            Uri.parse("$baseUrl/gradio_api/call/v2/predict"),

            headers: {
              "Content-Type": "application/json",
              "User-Agent": "SkinVisionAI-Mobile-App",
            },

            body: jsonEncode({
              "image": {
                "path": uploadedPath,

                "meta": {"_type": "gradio.FileData"},
              },
            }),
          )
          .timeout(const Duration(seconds: 90));

      if (predictResponse.statusCode != 200) {
        throw Exception("Prediction gagal: ${predictResponse.body}");
      }

      final eventId = jsonDecode(predictResponse.body)["event_id"];

      print("Event ID: $eventId");

      // ===============================
      // STEP 3
      // Get Result
      // ===============================

      final resultResponse = await http
          .get(
            Uri.parse("$baseUrl/gradio_api/call/predict/$eventId"),

            headers: {"User-Agent": "SkinVisionAI-Mobile-App"},
          )
          .timeout(const Duration(seconds: 120));

      if (resultResponse.statusCode != 200) {
        throw Exception("Gagal mengambil hasil prediksi");
      }

      final result = parseSSE(resultResponse.body);

      return DiagnosisModel.fromGradio(result);
    } on SocketException {
      throw Exception("Tidak dapat terhubung ke server");
    } on FormatException {
      throw Exception("Format response server tidak valid");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// ===============================
  /// PARSE SERVER SENT EVENT
  /// ===============================

  static List<dynamic> parseSSE(String body) {
    final lines = body.split("\n");

    for (final line in lines) {
      if (line.startsWith("data:")) {
        final jsonString = line.replaceFirst("data:", "").trim();

        return jsonDecode(jsonString);
      }
    }

    throw Exception("Data prediksi tidak ditemukan");
  }
}
