import 'dart:io';

abstract class StorageBase {
  Future<String> uploadPhoto(String kresCode, String kresAdi, String ogrID,
      String fileType, File yuklenecekDosya);
  Future<bool> deletePhoto(String ogrID, String url);
}
