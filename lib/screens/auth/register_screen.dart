import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  final auth = AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(

            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context)
                          .size
                          .height -
                      50,
            ),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [

                const SizedBox(height: 20),

                IconButton(
                  alignment:
                      Alignment.centerLeft,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),

                const SizedBox(height: 10),

                const Icon(
                  Icons.person_add_alt_1,
                  size: 100,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Buat Akun",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Daftar untuk menggunakan SkinVision AI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller:
                      emailController,

                  keyboardType:
                      TextInputType.emailAddress,

                  decoration: InputDecoration(
                    labelText: "Email",

                    prefixIcon:
                        const Icon(
                      Icons.email,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller:
                      passwordController,

                  obscureText: true,

                  decoration: InputDecoration(
                    labelText: "Password",

                    prefixIcon:
                        const Icon(
                      Icons.lock,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller:
                      confirmPasswordController,

                  obscureText: true,

                  decoration: InputDecoration(
                    labelText:
                        "Konfirmasi Password",

                    prefixIcon:
                        const Icon(
                      Icons.lock_outline,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 55,

                  child: ElevatedButton(

                    onPressed: () async {

                      if (passwordController.text !=
                          confirmPasswordController.text) {

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Password tidak sama",
                            ),
                          ),
                        );

                        return;
                      }

                      try {

                        await auth.register(
                          email:
                              emailController.text
                                  .trim(),

                          password:
                              passwordController.text
                                  .trim(),
                        );

                        if (mounted) {

                          ScaffoldMessenger.of(
                                  context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Registrasi berhasil",
                              ),
                            ),
                          );

                          Navigator.pop(
                              context);
                        }

                      } catch (e) {

                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          SnackBar(
                            content:
                                Text(e.toString()),
                          ),
                        );
                      }
                    },

                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  child: const Text(
                    "Sudah punya akun? Masuk",
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}