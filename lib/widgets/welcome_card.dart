import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: const Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  "Deteksi Penyakit Kulit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(
                  "Analisis kondisi kulit menggunakan AI",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.health_and_safety,
            color: Colors.white,
            size: 60,
          )
        ],
      ),
    );
  }
}