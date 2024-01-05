import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageUtils {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static Future<void> uploadFile(String storagePath, String filePath) async {
    final File file = File(filePath);
    final Reference ref = _firebaseStorage.ref(storagePath);

    await ref.putFile(file);
  }

  static Future<void> deleteFile(String url) async {
    await _firebaseStorage.refFromURL(url).delete().onError((e, _) => debugPrint("Error deleting a file: $e"));
  }

  static Future<String> getDownloadURL(String storagePath) async {
    String downloadURL = await _firebaseStorage.ref(storagePath).getDownloadURL();

    return downloadURL;
  }

  static Future<bool> fileExists(String filePath) async {
    try {
      final storageRef = _firebaseStorage.ref(filePath);
      await storageRef.getDownloadURL();
      return true;
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        return false;
      } else {
        rethrow;
      }
    }
  }
}