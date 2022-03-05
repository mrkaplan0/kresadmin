import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kresadmin/services/base/StorageBase.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late Reference _storageReference;

  @override
  Future<String> uploadPhoto(String ogrID, String ogrAdi, String fileType,
      File yuklenecekDosya) async {
    DateTime now = DateTime.now();
    _storageReference =
        _firebaseStorage.ref().child(ogrID).child(fileType).child("$now.png");
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask).ref.getDownloadURL();

    return url;
  }

  @override
  Future<bool> deletePhoto(String ogrID, String url) async {
    await _firebaseStorage.refFromURL(url).delete();
    return true;
  }
}
