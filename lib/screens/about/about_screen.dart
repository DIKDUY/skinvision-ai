import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          "Tentang Aplikasi",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.health_and_safety,
                size: 70,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "SkinVision AI",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Deteksi Penyakit Kulit Menggunakan CNN Berbasis Explainable AI",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: const Padding(
                padding: EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Deskripsi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "SkinVision AI merupakan aplikasi mobile yang membantu pengguna melakukan identifikasi awal penyakit kulit menggunakan teknologi Deep Learning berbasis Convolutional Neural Network (CNN).",
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: const Padding(
                padding: EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Teknologi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    ListTile(
                      leading:
                          Icon(Icons.smart_toy),
                      title:
                          Text("CNN Deep Learning"),
                    ),

                    ListTile(
                      leading:
                          Icon(Icons.visibility),
                      title:
                          Text("SHAP Explainable AI"),
                    ),

                    ListTile(
                      leading:
                          Icon(Icons.storage),
                      title:
                          Text("Firebase Firestore"),
                    ),

                    ListTile(
                      leading:
                          Icon(Icons.phone_android),
                      title:
                          Text("Flutter Mobile"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: const Padding(
                padding: EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Dataset",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "HAM10000 Dataset\n(Human Against Machine with 10,000 Dermatoscopic Images)",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: const Padding(
                padding: EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Tim Pengembang",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Ketua Kelompok : Muhammad Fris Setiawan - 20230801427\n\nAnggota :\n1. Muhammad Ridho Faturahman - 20230801456\n2. Siti Munawaroh - 20230801457\n3. Dicky Prawira - 20230801426\n4. Mahdi Nursubhi A - 20230801431",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}