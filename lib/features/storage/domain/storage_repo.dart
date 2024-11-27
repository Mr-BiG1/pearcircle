import 'dart:typed_data';

abstract class StorageRepo {
  //upload image on mobile platform
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // upload image in web platform
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

//upload post image on mobile platform
  Future<String?> uploadPostProfileImageMobile(String path, String fileName);

  // upload post  image in web platform
  Future<String?> uploadPostProfileImageWeb(Uint8List fileBytes, String fileName);
}
