import 'dart:io';

abstract class StorageBase {
  Future<String> uploadPhoto(
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya);
  Future<bool> deletePhoto(String ogrID, String url);
}
