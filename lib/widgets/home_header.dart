import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [

        const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Halo 👋",
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            Text(
              "Selamat Datang",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        CircleAvatar(
          radius: 25,
          child: Icon(Icons.person),
        )
      ],
    );
  }
}