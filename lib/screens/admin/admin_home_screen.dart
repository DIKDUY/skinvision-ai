import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () => logout(context),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("diagnosis")
                        .snapshots(),

                    builder: (context, snapshot) {
                      int total = 0;

                      if (snapshot.hasData) {
                        total = snapshot.data!.docs.length;
                      }

                      return Card(
                        elevation: 3,

                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Column(
                            children: [
                              const Icon(
                                Icons.analytics,
                                size: 40,
                                color: Colors.blue,
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Total Diagnosis",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                total.toString(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("diagnosis")
                        .snapshots(),

                    builder: (context, snapshot) {
                      int totalUser = 0;

                      if (snapshot.hasData) {
                        final ids = snapshot.data!.docs.map((e) {
                          return (e.data() as Map<String, dynamic>)["uid"];
                        }).toSet();

                        totalUser = ids.length;
                      }

                      return Card(
                        elevation: 3,

                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Column(
                            children: [
                              const Icon(
                                Icons.people,
                                size: 40,
                                color: Colors.green,
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Total User",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                totalUser.toString(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Riwayat Diagnosis",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("diagnosis")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("Belum ada data"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,

                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          title: Text(data["disease"] ?? "-"),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(data["email"] ?? "Tidak ada email"),

                              Text("Confidence : ${data["confidence"]} %"),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
