import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:peer_circle/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // profile  pic  upload  to storage.
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }


// post  profile  pic  upload  to storage.

@override
  Future<String?> uploadPostProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

@override
  Future<String?> uploadPostProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  // mobile  platform  (files)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      final file = File(path);
      final storageRef = storage.ref().child('$folder/$fileName');

      // uploading the files.
      final uploadTask = await storageRef.putFile(file);
      //get image download url

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // web platform  on(bites)
  // mobile  platform  (files)
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      final storageRef = storage.ref().child('$folder/$fileName');

      // uploading the files.
      final uploadTask = await storageRef.putData(fileBytes);
      //get image download url

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
