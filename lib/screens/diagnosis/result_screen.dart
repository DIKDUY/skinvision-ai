import 'package:flutter/material.dart';
import 'detail_screen.dart';

class ResultScreen extends StatelessWidget {
  final String disease;
  final double confidence;

  const ResultScreen({
    super.key,
    required this.disease,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Diagnosis"),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety, size: 100, color: Colors.teal),

            const SizedBox(height: 20),

            Text(
              disease,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Confidence: ${confidence.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(disease: disease),
                    ),
                  );
                },
                child: const Text("Lihat Detail"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
