import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageService {

  final FirebaseStorage storage =
      FirebaseStorage.instance;

  Future<String> uploadImage(
      File imageFile) async {

    String fileName =
        basename(imageFile.path);

    Reference ref = storage
        .ref()
        .child('diagnosis_images/$fileName');

    UploadTask uploadTask =
        ref.putFile(imageFile);

    await uploadTask;

    return await ref.getDownloadURL();
  }
}