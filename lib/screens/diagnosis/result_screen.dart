import 'package:flutter/material.dart';

import '../../models/diagnosis_model.dart';
import 'detail_screen.dart';

class ResultScreen extends StatelessWidget {
  final DiagnosisModel diagnosis;

  const ResultScreen({super.key, required this.diagnosis});

  double _parseConfidence(String value) {
    try {
      double result = double.parse(value.replaceAll("%", "").trim()) / 100;

      return result.clamp(0.0, 1.0);
    } catch (_) {
      return 0;
    }
  }

  Color _confidenceColor(double value) {
    if (value >= 0.8) {
      return Colors.green;
    } else if (value >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final confidence = _parseConfidence(diagnosis.confidence);
    final confidenceColor = _confidenceColor(confidence);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          "Hasil Diagnosis",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // ==========================
            // HEADER
            // ==========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),

              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.health_and_safety_rounded,
                      color: Colors.teal,
                      size: 70,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: const Text(
                      "AI Prediction",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    diagnosis.prediction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    diagnosis.confidence,
                    style: TextStyle(
                      fontSize: 34,
                      color: confidenceColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: confidence,
                      minHeight: 14,
                      valueColor: AlwaysStoppedAnimation(confidenceColor),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Confidence Level",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================
            // DESKRIPSI
            // ==========================
            _buildInfoCard(
              icon: Icons.description_outlined,
              title: "Deskripsi Penyakit",
              content: diagnosis.description,
            ),

            const SizedBox(height: 18),

            // ==========================
            // REKOMENDASI
            // ==========================
            _buildInfoCard(
              icon: Icons.medical_services_outlined,
              title: "Rekomendasi",
              content: diagnosis.recommendation,
            ),

            const SizedBox(height: 18),

            // ==========================
            // TOP 3 PREDICTION
            // ==========================
            _buildInfoCard(
              icon: Icons.analytics_outlined,
              title: "Top 3 Prediction",
              content: diagnosis.top3,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.menu_book_outlined),

                label: const Text(
                  "Lihat Detail Penyakit",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(
                        disease: diagnosis.prediction,
                        description: diagnosis.description,
                        recommendation: diagnosis.recommendation,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: OutlinedButton.icon(
                icon: const Icon(Icons.home),

                label: const Text("Kembali"),

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.teal, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          SelectableText(
            content.isEmpty ? "-" : content,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}
