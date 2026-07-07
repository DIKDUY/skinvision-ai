import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String disease;

  final String description;

  final String recommendation;

  const DetailScreen({
    super.key,

    required this.disease,

    required this.description,

    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Penyakit"),

        backgroundColor: Colors.teal,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Text(
                disease,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 24,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            buildCard(title: "Deskripsi Penyakit", content: description),

            const SizedBox(height: 20),

            buildCard(
              title: "Gejala",

              content:
                  "Perhatikan perubahan bentuk, warna, ukuran, atau perkembangan lesi kulit.",
            ),

            const SizedBox(height: 20),

            buildCard(title: "Pencegahan", content: recommendation),
          ],
        ),
      ),
    );
  }

  Widget buildCard({required String title, required String content}) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(content, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
