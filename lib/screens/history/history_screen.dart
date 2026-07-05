import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../diagnosis/result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Diagnosis")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("diagnosis")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada riwayat diagnosis"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final String disease = data["disease"] ?? "-";
              final double confidence =
                  (data["confidence"] as num?)?.toDouble() ?? 0.0;

              final Timestamp? timestamp = data["createdAt"] as Timestamp?;
              String tanggal = "-";

              if (timestamp != null) {
                final date = timestamp.toDate();
                tanggal = "${date.day}/${date.month}/${date.year}";
              }

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.health_and_safety, color: Colors.white),
                  ),
                  title: Text(
                    disease,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text("Confidence: ${confidence.toStringAsFixed(1)}%"),
                      Text(tanggal, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          disease: disease,
                          confidence: confidence,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
