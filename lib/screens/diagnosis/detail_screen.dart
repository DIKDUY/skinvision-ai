import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {

  final String disease;

  const DetailScreen({
    super.key,
    required this.disease,
  });

  Map<String, dynamic> getDiseaseData() {

    final diseases = {

      "Melanoma": {
        "description":
            "Jenis kanker kulit yang berkembang dari sel melanosit.",
        "symptoms":
            "Perubahan bentuk, ukuran, atau warna tahi lalat.",
        "prevention":
            "Gunakan sunscreen dan hindari paparan sinar UV berlebih."
      },

      "Basal Cell Carcinoma": {
        "description":
            "Kanker kulit yang berkembang pada sel basal.",
        "symptoms":
            "Benjolan kecil mengkilap atau luka yang tidak sembuh.",
        "prevention":
            "Gunakan pelindung kulit saat berada di luar ruangan."
      },

      "Actinic Keratoses": {
        "description":
            "Lesi kulit akibat paparan sinar matahari jangka panjang.",
        "symptoms":
            "Kulit kasar dan bersisik.",
        "prevention":
            "Kurangi paparan sinar UV."
      },

      "Benign Keratosis": {
        "description":
            "Pertumbuhan kulit jinak yang umum terjadi.",
        "symptoms":
            "Bercak kecoklatan atau hitam.",
        "prevention":
            "Pantau perubahan pada kulit."
      },

      "Dermatofibroma": {
        "description":
            "Benjolan kulit jinak yang berasal dari jaringan ikat.",
        "symptoms":
            "Benjolan kecil berwarna coklat.",
        "prevention":
            "Periksa jika terjadi perubahan bentuk."
      },

      "Melanocytic Nevi": {
        "description":
            "Tahi lalat yang terbentuk dari sel melanosit.",
        "symptoms":
            "Bintik coklat atau hitam pada kulit.",
        "prevention":
            "Pantau perubahan ukuran dan warna."
      },

      "Vascular Lesions": {
        "description":
            "Kelainan pembuluh darah pada kulit.",
        "symptoms":
            "Bercak merah atau ungu.",
        "prevention":
            "Periksakan jika bertambah besar."
      }
    };

    return diseases[disease] ??
        {
          "description":
              "Informasi tidak tersedia.",
          "symptoms":
              "-",
          "prevention":
              "-"
        };
  }

  @override
  Widget build(BuildContext context) {

    final data = getDiseaseData();

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Detail Penyakit",
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              disease,
              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Deskripsi",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(data["description"]),

            const SizedBox(height: 20),

            Text(
              "Gejala",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(data["symptoms"]),

            const SizedBox(height: 20),

            Text(
              "Pencegahan",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(data["prevention"]),
          ],
        ),
      ),
    );
  }
}