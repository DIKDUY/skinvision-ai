import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/diagnosis_model.dart';
import '../../services/api_service.dart';
import 'result_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  File? image;

  final ImagePicker picker = ImagePicker();

  bool loading = false;

  String loadingText = "";

  Future<void> pickFromCamera() async {
    final picked = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> pickFromGallery() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> uploadAndAnalyze() async {
    if (image == null) {
      showMessage("Silakan pilih gambar terlebih dahulu.");
      return;
    }

    final fileSize = await image!.length();

    if (fileSize > 5 * 1024 * 1024) {
      showMessage("Ukuran gambar terlalu besar. Maksimal 5 MB.");
      return;
    }

    setState(() {
      loading = true;
      loadingText = "Mengunggah gambar...";
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        loadingText = "AI sedang menganalisis kulit...";
      });

      final DiagnosisModel result = await ApiService.predictDisease(image!);

      setState(() {
        loadingText = "Menyimpan hasil diagnosis...";
      });

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection("diagnosis").add({
        "uid": user?.uid,
        "email": user?.email,
        "disease": result.prediction,
        "confidence": result.confidence,
        "description": result.description,
        "recommendation": result.recommendation,
        "top3": result.top3,
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(diagnosis: result)),
      );
    } catch (e) {
      debugPrint("Diagnosis Error: $e");

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      showErrorDialog();
    }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text("Diagnosis Gagal"),
            ],
          ),
          content: const Text(
            "Tidak dapat melakukan diagnosis saat ini.\n\n"
            "Periksa koneksi internet Anda atau coba lagi beberapa saat.",
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Diagnosis AI"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                Container(
                  height: 260,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: Colors.grey.shade300),
                  ),

                  clipBehavior: Clip.antiAlias,

                  child: image != null
                      ? Image.file(image!, fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: const [
                            Icon(
                              Icons.image_outlined,
                              size: 70,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 12),

                            Text(
                              "Belum ada gambar",

                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "Pilih sumber gambar",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,

                        child: ElevatedButton.icon(
                          onPressed: loading ? null : pickFromCamera,

                          icon: const Icon(Icons.camera_alt),

                          label: const Text("Kamera"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,

                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: SizedBox(
                        height: 52,

                        child: ElevatedButton.icon(
                          onPressed: loading ? null : pickFromGallery,

                          icon: const Icon(Icons.photo_library),

                          label: const Text("Galeri"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,

                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,

                  height: 56,

                  child: ElevatedButton.icon(
                    onPressed: loading ? null : uploadAndAnalyze,

                    icon: const Icon(Icons.analytics),

                    label: const Text(
                      "Analisis Kulit",

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,

                      foregroundColor: Colors.white,

                      elevation: 3,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================
          // LOADING OVERLAY
          // ==========================
          if (loading)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  color: Colors.black.withValues(alpha: 0.55),

                  child: Center(
                    child: Container(
                      width: 320,

                      margin: const EdgeInsets.symmetric(horizontal: 24),

                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(24),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,

                            blurRadius: 20,

                            offset: Offset(0, 8),
                          ),
                        ],
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          const SizedBox(
                            width: 60,

                            height: 60,

                            child: CircularProgressIndicator(
                              strokeWidth: 4,

                              color: Colors.teal,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            "AI Sedang Menganalisis",

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontSize: 20,

                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            loadingText,

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              fontSize: 15,

                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 20),

                          const LinearProgressIndicator(),

                          const SizedBox(height: 20),

                          const Text(
                            "Mohon tunggu beberapa saat.\n"
                            "Jangan menutup aplikasi.",

                            textAlign: TextAlign.center,

                            style: TextStyle(color: Colors.grey, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
