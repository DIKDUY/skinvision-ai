import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/diagnosis_model.dart';
import '../diagnosis/result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Diagnosis"),

        backgroundColor: Colors.teal,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("diagnosis")
            // hanya data user yang login
            .where("uid", isEqualTo: user?.uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada riwayat diagnosis"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),

            itemCount: docs.length,

            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final diagnosis = DiagnosisModel(
                prediction: data["disease"] ?? "-",

                confidence: data["confidence"] ?? "0%",

                description: data["description"] ?? "-",

                recommendation: data["recommendation"] ?? "-",

                top3: data["top3"] ?? "-",
              );

              String date = "";

              if (data["createdAt"] != null) {
                Timestamp timestamp = data["createdAt"];

                DateTime time = timestamp.toDate();

                date = "${time.day}-${time.month}-${time.year}";
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
                    diagnosis.prediction,

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 5),

                      Text("Confidence : ${diagnosis.confidence}"),

                      if (date.isNotEmpty) Text("Tanggal : $date"),
                    ],
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => ResultScreen(diagnosis: diagnosis),
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
