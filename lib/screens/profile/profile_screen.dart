import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(
      BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Profil Pengguna",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            const CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user?.email ?? "-",
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.email),
                title:
                    const Text("Email"),
                subtitle:
                    Text(user?.email ?? "-"),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.logout,
                ),

                label: const Text(
                  "Logout",
                ),

                onPressed: () =>
                    logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}