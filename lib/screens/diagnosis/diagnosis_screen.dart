import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'result_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  File? image;
  final picker = ImagePicker();
  bool loading = false;

  Future pickFromCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  Future pickFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  Future uploadAndAnalyze() async {
    if (image == null) return;

    setState(() => loading = true);

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://YOUR_API_URL/predict"),
      );

      request.files.add(await http.MultipartFile.fromPath("file", image!.path));

      var response = await request.send();
      var res = await response.stream.bytesToString();

      final data = jsonDecode(res);

      final disease = data["disease"];
      final confidence = (data["confidence"] ?? 0).toDouble();

      await FirebaseFirestore.instance.collection("diagnosis").add({
        "uid": FirebaseAuth.instance.currentUser?.uid,
        "email": FirebaseAuth.instance.currentUser?.email,
        "disease": disease,
        "confidence": confidence,
        "createdAt": Timestamp.now(),
      });

      if (!mounted) return;

      setState(() => loading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ResultScreen(disease: disease, confidence: confidence),
        ),
      );
    } catch (e) {
      setState(() => loading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diagnosis AI"),
        backgroundColor: Colors.teal,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: image != null
                  ? Image.file(image!, fit: BoxFit.cover)
                  : const Center(child: Text("Belum ada gambar")),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickFromCamera,
                    child: const Text("Kamera"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickFromGallery,
                    child: const Text("Gallery"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : uploadAndAnalyze,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Analisis"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
