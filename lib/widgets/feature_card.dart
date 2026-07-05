import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 120,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color:
                  Colors.grey.shade300,
            )
          ],
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(title)
          ],
        ),
      ),
    );
  }
}