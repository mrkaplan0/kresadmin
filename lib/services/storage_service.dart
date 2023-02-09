import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kresadmin/services/base/StorageBase.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late Reference _storageReference;

  @override
  Future<String> uploadPhoto(String kresCode, String kresAdi, String ogrID,
      String fileType, File yuklenecekDosya) async {
    DateTime now = DateTime.now();
    _storageReference = _firebaseStorage
        .ref()
        .child(kresCode)
        .child(ogrID)
        .child(fileType)
        .child("$now.jpeg");
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }

  @override
  Future<bool> deletePhoto(String url) async {
    await _firebaseStorage.refFromURL(url).delete();
    return true;
  }
}
